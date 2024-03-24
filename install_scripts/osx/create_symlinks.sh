#!/bin/sh
#---------- Create various symlinks ----------

# Assumes directories actually exist on new host
# Call this from home dir
ROOT_DIR="$(git rev-parse --show-toplevel)"

ln -sfF "$ROOT_DIR"/.zshrc "$HOME"/.zshrc
ln -sfF "$ROOT_DIR"/starship.toml "$HOME"/.config/starship.toml
ln -sfF "$ROOT_DIR"/alacritty.toml "$HOME"/.config/alacritty/alacritty.toml
ln -sfF "$ROOT_DIR"/.tmux.conf "$HOME"/.tmux.conf
ln -sfF "$ROOT_DIR"/lua "$HOME"/.config/nvim/
ln -sfF "$ROOT_DIR"/init.lua "$HOME"/.config/nvim/init.lua
ln -sfF "$ROOT_DIR"/.p10k.zsh "$HOME"/.p10k.zsh
