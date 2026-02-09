#!/bin/bash

sudo apt update && sudo apt upgrade

sudo add-apt-repository ppa:neovim-ppa/stable

sudo apt update

sudo apt-get -y install \
    neovim \
    tmux \
    alacritty \
    git \
    git-lfs \
    zsh
