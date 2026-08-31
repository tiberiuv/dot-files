#!/bin/zsh

# Meant to be *sourced* from an interactive zsh (`alias update-all` does this):
# zinit is a shell function defined by ~/.zshrc, not a binary, so running this
# file directly would skip the zinit steps.

[[ ${commands[rustup]} ]] && rustup update

if [[ $(uname -s) == "Darwin" ]]; then
  # Update Homebrew (Cask) & packages
  brew update
  brew upgrade
  brew upgrade --cask
else
  # Debian/Ubuntu equivalents of the brew block above
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  [[ ${commands[pipx]} ]] && pipx upgrade-all
  [[ ${commands[mise]} ]] && mise upgrade
fi

# Rust CLI tools installed with cargo-binstall don't self-update
[[ ${commands[cargo-binstall]} ]] && cargo binstall --no-confirm --locked \
  eza bat procs ripgrep trunk wasm-bindgen-cli fnm starship stylua

# Update yarn packages
[[ ${commands[yarn]} ]] && yarn global upgrade

# Update zinit & packages
if (( ${+functions[zinit]} )); then
  zinit self-update
  zinit update
else
  echo "zinit not loaded: source this file from an interactive zsh (update-all)." >&2
fi

# Update nvim plugins
[[ ${commands[nvim]} ]] && nvim --headless "+Lazy! sync" +qa
