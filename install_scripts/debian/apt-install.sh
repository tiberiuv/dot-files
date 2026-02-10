#!/bin/bash

sudo apt update && sudo apt upgrade

sudo add-apt-repository ppa:neovim-ppa/unstable -y

sudo apt update

sudo apt install -y \
    neovim \
    tmux \
    alacritty \
    git \
    git-lfs \
    zsh
