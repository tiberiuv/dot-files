#!/bin/zsh

rustup update

# Update Homebrew (Cask) & packages
brew update
brew upgrade
brew upgrade --cask

# Update yarn packages
yarn global upgrade

# Update zinit & packages
zinit self-update
zinit update

# Update nvim plugins
nvim --headless "+Lazy! sync" +qa
