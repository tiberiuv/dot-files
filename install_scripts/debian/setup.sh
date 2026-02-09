#!/bin/bash

. ./install_scripts/shared/setup-dirs.sh
. ./install_scripts/shared/create_symlinks.sh
. ./install_scripts/debian/apt-install.sh

# Install zinit - package manager for zsh shell
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

zsh ~/.zshrc

sudo chsh -s /bin/zsh "$USER"
