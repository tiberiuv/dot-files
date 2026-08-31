#!/bin/zsh

rustup update

if [[ $(uname -s) == "Darwin" ]]; then
  # Update Homebrew (Cask) & packages
  brew update
  brew upgrade
  brew upgrade --cask
else
  # Debian/Ubuntu equivalents of the brew block above
  sudo apt update
  sudo apt upgrade -y
  [[ ${commands[pipx]} ]] && pipx upgrade-all
  [[ ${commands[mise]} ]] && mise upgrade
fi

# Update yarn packages
[[ ${commands[yarn]} ]] && yarn global upgrade

# Update zinit & packages
zinit self-update
zinit update

# Update nvim plugins
nvim --headless "+Lazy! sync" +qa
