#!/bin/sh
#---------- Create various symlinks ----------

# Assumes directories actually exist on new host
# Call this from home dir
ROOT_DIR="$(git rev-parse --show-toplevel)"

# `ln -F` (clobber an existing real directory at the target) is BSD/macOS-only
# and errors out on Debian/Ubuntu's GNU coreutils `ln`. Do the equivalent
# ourselves so this works on both: if the target is a real (non-symlink)
# directory, remove it first, then let `ln -sf` handle files/symlinks/missing.
symlink() {
  src="$1"
  dst="$2"
  if [ -d "$dst" ] && [ ! -L "$dst" ]; then
    rm -rf "$dst"
  fi
  ln -sf "$src" "$dst"
}

symlink "$ROOT_DIR"/.zshrc "$HOME"/.zshrc
symlink "$ROOT_DIR"/starship.toml "$HOME"/.config/starship.toml
symlink "$ROOT_DIR"/alacritty.toml "$HOME"/.config/alacritty/alacritty.toml
symlink "$ROOT_DIR"/.tmux.conf "$HOME"/.tmux.conf
symlink "$ROOT_DIR"/lua "$HOME"/.config/nvim/lua
symlink "$ROOT_DIR"/init.lua "$HOME"/.config/nvim/init.lua
symlink "$ROOT_DIR"/.p10k.zsh "$HOME"/.p10k.zsh
symlink "$ROOT_DIR"/claude/CLAUDE.md "$HOME"/.claude/CLAUDE.md
