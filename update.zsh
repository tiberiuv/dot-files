#!/bin/zsh

# Update App Store apps
#sudo softwareupdate -i -a

rustup update

# Update Homebrew (Cask) & packages
brew update
brew upgrade

# Update yarn packages
yarn global upgrade

# Update zinit & packages
zinit self-update
zinit update

# Update nvim plugins
nvim -c PackerUpdate
