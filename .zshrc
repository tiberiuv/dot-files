if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  . "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# ------------------------------------------------------------ #
# Env vars
# ------------------------------------------------------------ #
# Declared before the PATH block below, which references several of them.
export RUST_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"
export PYENV_ROOT="$HOME/.pyenv"
export GOPATH="$HOME/go"
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export EDITOR=nvim
export GPG_TTY=$TTY
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS='ow=36:di=34:fi=32:ex=31:ln=35:'
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# For minikube
export KUBERNETES_PROVIDER=docker

# ------------------------------------------------------------ #
# Path
# ------------------------------------------------------------ #
# Shells inside tmux inherit PATH and then prepend all of the below again.
# Both names: -U on the array alone does not dedupe the `export PATH=...:$PATH`
# assignments below, which go through the scalar.
typeset -U PATH path
# Everything derived from $HOMEBREW_PREFIX has to stay inside the Darwin
# branch: on Linux the variable is empty, so those lines would otherwise
# inject /bin, /sbin, /opt/... into PATH and, worse, export LDFLAGS/CPPFLAGS
# pointing at non-existent dirs (which breaks pyenv/cargo source builds).
#
# Apple Silicon only -- no /usr/local fallback.
if [[ $OSTYPE == darwin* ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  export RUST_ANALYZER_TARGET="aarch64-apple-darwin"

  # No GOROOT: go comes from nix and locates its own. A stale GOROOT gives
  # "go: cannot find GOROOT directory".

  export PATH=$HOMEBREW_PREFIX/bin:$PATH
  export PATH=$HOMEBREW_PREFIX/sbin:$PATH
  export PATH=$HOMEBREW_PREFIX/opt/llvm/bin:$PATH
  export PATH=$HOMEBREW_PREFIX/opt/openssl@3/bin:$PATH
  export PATH=$PATH:$HOMEBREW_PREFIX/texlive/2019/texmf-dist/tex/xelatex
  export PATH=$PATH:/Applications

  # Compiler flags
  export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
  export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
elif [[ $OSTYPE == linux* ]]; then
  # No GOROOT here either -- see the Darwin branch above.
  export RUST_ANALYZER_TARGET="$(uname -m)-unknown-linux-gnu"

  export PATH=$HOME/.tfenv/bin:$PATH
fi

export PATH=$PYENV_ROOT/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# /home/coder/.local/bin: Coder's claude-code module greps for this literal
# path and appends a PATH line when it is missing.
# ------------------------------------------------------------ #
bindkey -e
# The emacs keymap only binds ESC-b/ESC-f. Alt-arrow arrives as CSI 1;3 from
# tmux (xterm-keys) and xterm-style terminals, or ESC-prefixed from terminals
# that send Alt as a bare ESC.
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word

WORDCHARS="*?[]~=&;!#$%^(){}<>"
# ------------------------------------------------------------ #
COMPLETION_WAITING_DOTS=true
DISABLE_MAGIC_FUNCTIONS=true
# ------------------------------------------------------------ #
# FZF
# ------------------------------------------------------------ #
# Not unset: the _fzf_compgen_* functions read it at completion time.
_fzf_ignore='{node_modules,.git,*.lock,target,dist}'
export FZF_DEFAULT_COMMAND="rg --smart-case --files --hidden --follow --no-messages --glob '!$_fzf_ignore'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

_fzf_compgen_path() {
  rg --smart-case --files --hidden --follow --no-messages --glob "!$_fzf_ignore" -- "$1"
}

# fd, not rg: `rg --files` can only list files, so `cd **<Tab>` offered them.
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude "$_fzf_ignore" . "$1"
}

# ------------------------------------------------------------ #
setopt AUTO_CD              # Change directory without cd
setopt AUTO_PUSHD           # Make cd push each old directory onto the stack
setopt no_beep
unsetopt LIST_BEEP          # Don't beep on an ambiguous completion
setopt auto_menu            # Automatically use menu completion
setopt auto_list            # Automatically List Choices On Ambiguous Completion.
setopt always_to_end        # Vove cursor to end if word had one match
setopt complete_in_word     # Complete From Both Ends Of A Word.

HISTFILE=${HOME}/.zsh_history
HISTSIZE=120000             # Larger than $SAVEHIST for HIST_EXPIRE_DUPS_FIRST to work
SAVEHIST=100000

setopt EXTENDED_HISTORY         # Save time stamps and durations
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first
setopt HIST_IGNORE_DUPS         # Do not enter 2 consecutive duplicates into history
setopt HIST_IGNORE_SPACE        # Ignore command lines with leading spaces
setopt HIST_VERIFY              # Reload results of history expansion before executing
setopt INC_APPEND_HISTORY       # Constantly update $HISTFILE
setopt SHARE_HISTORY            # Constantly share history between shell instances
setopt path_dirs                # Perform Path Search Even On Command Names With Slashes.
setopt auto_param_slash         # If Completed Parameter Is A Directory, Add A Trailing Slash.

# ------------------------------ Aliases ------------------------------ #

alias kc="kubectl"
alias kcgc='kubectl config get-contexts'
alias kcuc='kubectl config use-context'
alias ssh="TERM=xterm-256color ssh"
# The checkout need not live at ~/dot-files. %x is the file being sourced --
# this .zshrc, a symlink into the checkout -- so :A:h gives the repo root.
DOTFILES_DIR=${${(%):-%x}:A:h}
alias update-all=". $DOTFILES_DIR/update.zsh"
# Codex profile files overlay the local config; config.toml has no include.
codex() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      -p|--profile|-p?*|--profile=*) command codex "$@"; return ;;
    esac
  done
  command codex --profile shared "$@"
}
# A function, not an alias: in a double-quoted alias awk's $1 was expanded
# (empty) at definition time, so every column was passed to `kubectl delete`.
clean_evicted() {
  kubectl get pod --no-headers | awk '$3 == "Evicted" { print $1 }' \
    | xargs -r kubectl delete pod
}
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'

if [[ $OSTYPE == darwin* ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

alias vim=nvim

# `tm` for the machine that owns the windows, `tm <device>` for anything
# attaching alongside it, so the two do not have to share a geometry.
#
# The extra member is reused rather than reaped: destroy-unattached takes
# effect the instant it is set, which destroys a session created detached
# before anything can attach to it.
tm() {
    local base=main
    local member=${1:-$base}
    tmux has-session -t "=$base" 2>/dev/null || tmux new-session -d -s "$base"
    if [[ "$member" != "$base" ]]; then
        tmux has-session -t "=$member" 2>/dev/null \
            || tmux new-session -d -t "$base" -s "$member"
    fi
    tmux attach-session -t "$member"
}

if (( ${+commands[eza]} )); then
  alias ls=eza
elif (( ${+commands[exa]} )); then
  alias ls=exa
fi
(( ${+commands[bat]} )) && alias cat=bat
(( ${+commands[procs]} )) && alias ps=procs

alias claude="claude --model opus"
# ------------------------------------------------------------ #
#
# ------------------------------------------------------------ #
# Zinit
# ------------------------------------------------------------ #
# Self-installing: this clone is the only zinit install step there is.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# ------------------------------------------------------------ #
# PROMPT
# ------------------------------------------------------------ #

zinit depth=1 lucid light-mode nocd for romkatv/powerlevel10k
POWERLEVEL10K_MODE="nerfont-complete"
setopt promptsubst

# ------------------------------------------------------------ #
# PLUGINS
# ------------------------------------------------------------ #
zinit wait"0a" lucid light-mode for \
  atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions

zinit wait lucid light-mode for \
  blockf atpull"zinit creinstall -q ." zsh-users/zsh-completions \
  zdharma-continuum/fast-syntax-highlighting

zinit wait lucid light-mode for zsh-users/zsh-history-substring-search

zinit wait lucid for \
  OMZL::git.zsh \
  atload"unalias grv" OMZP::git

# ------------------------------------------------------------ #
# Programs
# ------------------------------------------------------------ #
# Fzf
zinit ice depth"1" as"program" pick"bin/fzf" \
  atclone"rm -rf bin/fzf && bash install --key-bindings --completion --no-update-rc" \
  atpull"%atclone"
zinit light junegunn/fzf

zinit wait lucid light-mode for Aloxaf/fzf-tab

# ------------------------------------------------------------ #

autoload -Uz compinit
# Rebuild (and re-verify) the completion dump at most once a day; `compinit -C`
# skips that check. This used to read `[[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]`,
# which never worked: zsh does no filename generation inside `[[ ]]`, so the
# test was just "is this string non-empty" -- always true, so every shell start
# paid for a full compinit. Glob in an array assignment instead (bare glob
# qualifiers, so no extended_glob needed), and pin -d to the same path we test.
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
_zcompdump_stale=( $_zcompdump(N.mh+24) )
if (( $#_zcompdump_stale )) || [[ ! -f $_zcompdump ]]; then
	compinit -d $_zcompdump
else
	compinit -C -d $_zcompdump
fi
unset _zcompdump _zcompdump_stale

zstyle ":completion:*:match:*" original only
zstyle ":completion:*:git-checkout:*" sort false
zstyle ":completion:*:descriptions" format '[%d]'
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
# $realpath is expanded by fzf-tab at preview time, so keep it literal
_fzf_tab_ls=eza
(( ${+commands[eza]} )) || _fzf_tab_ls=exa
zstyle ":fzf-tab:complete:cd:*" fzf-preview "$_fzf_tab_ls -1 --color=always \$realpath"
zstyle ":fzf-tab:*" fzf-command fzf

# In the line editor, number of matches to show before asking permission
LISTMAX=9999

# Google Cloud SDK path + completion. The Caskroom location only exists on
# macOS ($HOMEBREW_PREFIX is empty on Linux); on Linux the SDK unpacks into
# ~/google-cloud-sdk or /usr/share.
for _gcloud_root in \
  "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" \
  "$HOME/google-cloud-sdk" \
  /usr/share/google-cloud-sdk; do
  if [[ -f $_gcloud_root/path.zsh.inc ]]; then
    . "$_gcloud_root/path.zsh.inc"
    [[ -f $_gcloud_root/completion.zsh.inc ]] && . "$_gcloud_root/completion.zsh.inc"
    break
  fi
done
unset _gcloud_root

# `<cmd> completion zsh` costs 35-55ms per shell, so its output is cached and
# regenerated only when the binary changes. Keyed on the resolved path, not
# just mtime: nix store files all carry mtime 1, so an upgraded kubectl is
# never "newer" than the cache -- but it does live at a new store path.
# Sets REPLY rather than sourcing: sourced inside a function, any typeset in
# the generated script would become function-local.
_completion_cache() {
  local bin=${commands[$1]} cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/$1-completion.zsh
  local stamp="# ${bin:A}" first
  [[ -n $bin ]] || return 1
  [[ -r $cache ]] && read -r first < $cache
  if [[ $first != "$stamp" || $bin -nt $cache ]]; then
    mkdir -p ${cache:h}
    { print -r -- "$stamp" && $1 completion zsh } >| $cache.$$ \
      && mv -f $cache.$$ $cache || { rm -f $cache.$$; return 1 }
  fi
  REPLY=$cache
}
for _cmd in kubectl velero; do
  _completion_cache $_cmd && . $REPLY
done
unset _cmd
unfunction _completion_cache

[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || . ~/.p10k.zsh

# Guarded on $PYENV_ROOT/versions: with no pyenv-owned interpreter the init
# only re-exports what system python already provides. --no-rehash leaves
# shims stale after installing a package with new entry points -- run
# `pyenv rehash` by hand then.
[[ ${commands[pyenv]} && -d $PYENV_ROOT/versions ]] && eval "$(pyenv init - --no-rehash)"

printf "\e[?1042l"

# Node version manager
[[ ${commands[fnm]} ]] && eval "$(fnm env)"

# Runtime version manager (provides lua 5.1 for the nvim toolchain)
[[ ${commands[mise]} ]] && eval "$(mise activate zsh)"

zinit cdreplay -q
