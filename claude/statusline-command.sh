#!/bin/sh
# Claude Code status line: pipe-separated, foreground colour only --
#   cwd | branch | model | context bar | 5h usage (reset) | 7d usage (reset)
#
# Built from the session JSON on stdin -- not derived from any shell PS1,
# since this machine's prompt is Powerlevel10k-generated rather than a plain
# PS1 string.
#
# FOREGROUND COLOUR ONLY, and no glyphs outside the block-drawing range.
# Both are hard constraints on this setup, each learned the slow way:
#   * 48;5;N background fills paint in a plain terminal but not on the
#     surface this line renders on, so a filled-block design shows as bare
#     text on an unpainted row.
#   * Codepoints in the BMP private-use area U+E000-F8FF occupy a cell and
#     render blank, which silently swallowed every Nerd Font icon and every
#     powerline separator. The font is not at fault -- the glyphs are all
#     present with real outlines. U+2588 and the eighth-blocks used by the
#     bar are ordinary block-drawing characters and are unaffected.
# Check /tmp/glyph-probe.sh before reaching for anything in U+E000-F8FF.

input=$(cat)

cwd=$(printf "%s" "$input" | jq -r '.workspace.current_dir // .cwd')
dir=$(printf "%s" "$cwd" | sed "s|^$HOME|~|")
model=$(printf "%s" "$input" | jq -r '.model.display_name')

# --no-optional-locks: this runs on every prompt render, don't contend with
# other git processes for the index lock.
branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)

# The payload carries used and remaining separately; take used directly
# rather than deriving it, so the bar and the number cannot disagree.
used=$(printf "%s" "$input" | jq -r '.context_window.used_percentage // empty')

now=$(date +%s)

C_DIR=75        # light blue
C_BRANCH=114    # green
C_MODEL=141     # lavender
C_LABEL=245     # muted label / units
C_TEXT=252      # bright reading
C_SEP=240       # pipes
C_TROUGH=238    # unfilled bar
C_DANGER=52     # unfilled bar past the context danger line

# Context is treated as bad from 60% used, well before the window is
# actually full: the useful signal is "start thinking about compacting",
# not "you ran out". That is a different question from the usage windows
# below, which genuinely only matter as they approach their own cap -- so
# the two deliberately do NOT share a colour ramp.
CTX_DANGER=60   # % used at which context counts as bad
CTX_WARN=45     # % used at which it starts warning

# Emoji, not Nerd Font glyphs: these are ordinary Unicode, so the private-use
# blanking above does not apply. Every one has default emoji presentation, so
# none needs a U+FE0F variation selector -- the VS16 forms (a bare U+23F1,
# say) render at inconsistent widths and would misalign the line. All are
# double-width; the trailing space keeps one clear cell after them.
ICON_DIR="\xf0\x9f\x93\x81"     # U+1F4C1 file folder
ICON_BRANCH="\xf0\x9f\x8c\xbf"  # U+1F33F herb
ICON_MODEL="\xf0\x9f\xa4\x96"   # U+1F916 robot
ICON_CTX="\xf0\x9f\xa7\xa0"     # U+1F9E0 brain
ICON_5H="\xe2\x8f\xb3"           # U+23F3 hourglass
ICON_7D="\xf0\x9f\x93\x85"      # U+1F4C5 calendar
ICON_SPEND="\xf0\x9f\x92\xb3"   # U+1F4B3 credit card

# round <float> -- nearest integer. Percentages are NOT clamped to 100: the
# CLI documents utilization above 1 as legitimate (usage running past a
# window's cap), so 100%+ is a real reading, not a bug to hide.
round() { awk -v v="$1" 'BEGIN { printf "%d", v + 0.5 }'; }

# load_color <pct> -- for the usage windows: green below 50, amber to 80,
# red above, measured against their own cap.
load_color() {
  if [ "$1" -lt 50 ]; then printf 114
  elif [ "$1" -lt 80 ]; then printf 221
  else printf 203
  fi
}

# ctx_color <pct> -- for context, which turns red at CTX_DANGER rather than
# near 100. See the constants above for why this is not load_color.
ctx_color() {
  if [ "$1" -ge "$CTX_DANGER" ]; then printf 203
  elif [ "$1" -ge "$CTX_WARN" ]; then printf 221
  else printf 114
  fi
}

# until_reset <epoch_seconds> -- compact time remaining, "" when absent.
# resets_at is unix epoch seconds (confirmed against the CLI's own code).
until_reset() {
  [ -n "$1" ] || return 0
  awk -v t="$1" -v n="$now" 'BEGIN {
    d = t - n
    if (d <= 0) { printf "now"; exit }
    h = int(d / 3600); m = int((d % 3600) / 60)
    if (h >= 24) {
      dd = int(h / 24); hh = h % 24
      if (hh) printf "%dd%dh", dd, hh; else printf "%dd", dd
    } else if (h > 0) {
      if (m) printf "%dh%dm", h, m; else printf "%dh", h
    } else printf "%dm", (m > 0 ? m : 1)
  }'
}

# bar <pct> <colour> [danger_pct] -- fixed-width meter filled left-to-right
# by pct, at eighth-of-a-cell resolution so it moves on roughly every 1%.
# With danger_pct, the UNFILLED cells at or past that mark are tinted, so the
# limit is visible on the meter as the fill approaches it rather than only
# announcing itself once crossed.
bar() {
  width=10
  eighths=$(awk -v r="$1" -v w=$width 'BEGIN {
    e = (r / 100) * w * 8 + 0.5; if (e > w * 8) e = w * 8; printf "%d", e
  }')
  full=$((eighths / 8))
  part=$((eighths % 8))

  b="\033[38;5;${2}m"
  i=0
  while [ "$i" -lt "$full" ]; do b="${b}█"; i=$((i + 1)); done
  if [ "$part" -gt 0 ] && [ "$full" -lt "$width" ]; then
    case $part in
      1) b="${b}▏" ;; 2) b="${b}▎" ;; 3) b="${b}▍" ;; 4) b="${b}▌" ;;
      5) b="${b}▋" ;; 6) b="${b}▊" ;; 7) b="${b}▉" ;;
    esac
    i=$((i + 1))
  fi
  b="${b}\033[38;5;${C_TROUGH}m"
  tinted=0
  while [ "$i" -lt "$width" ]; do
    if [ -n "$3" ] && [ "$tinted" -eq 0 ] && [ $((i * 100 / width)) -ge "$3" ]; then
      b="${b}\033[38;5;${C_DANGER}m"
      tinted=1
    fi
    b="${b}█"
    i=$((i + 1))
  done
  printf '%s' "$b"
}

# limit <icon> <label> <key> -- "(icon) 5h 42% (2h14m)", empty when absent.
limit() {
  pct=$(printf "%s" "$input" | jq -r ".rate_limits.$3.used_percentage // empty")
  [ -n "$pct" ] || return 0
  p=$(round "$pct")
  at=$(printf "%s" "$input" | jq -r ".rate_limits.$3.resets_at // empty")
  left=$(until_reset "$at")
  printf '%b \033[38;5;%dm%s \033[38;5;%dm%d%%' "$1" "$C_LABEL" "$2" "$(load_color "$p")" "$p"
  [ -n "$left" ] && printf '\033[38;5;%dm (%s)' "$C_LABEL" "$left"
}

SEP="\033[38;5;${C_SEP}m | "

out="${ICON_DIR} \033[38;5;${C_DIR}m${dir}"
[ -n "$branch" ] && out="${out}${SEP}${ICON_BRANCH} \033[38;5;${C_BRANCH}m${branch}"
out="${out}${SEP}${ICON_MODEL} \033[38;5;${C_MODEL}m${model}"

if [ -n "$used" ]; then
  p=$(round "$used")
  # Bold once past the danger line so it reads at a glance, not just by hue.
  ctx_emph=""
  [ "$p" -ge "$CTX_DANGER" ] && ctx_emph="\033[1m"
  out="${out}${SEP}${ICON_CTX} $(bar "$used" "$(ctx_color "$p")" "$CTX_DANGER")${ctx_emph}\033[38;5;$(ctx_color "$p")m ${p}%\033[0m"
fi

# label:key:icon
for w in "5h:five_hour:$ICON_5H" "7d:seven_day:$ICON_7D" "\$:spend_limit:$ICON_SPEND"; do
  rest=${w#*:}
  seg=$(limit "${rest#*:}" "${w%%:*}" "${rest%%:*}")
  [ -n "$seg" ] && out="${out}${SEP}${seg}"
done

printf "%b" "${out}\033[0m"
