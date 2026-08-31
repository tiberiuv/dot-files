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
    zsh \
    tree-sitter-cli \
    build-essential \
    cmake \
    ninja-build \
    automake \
    autogen \
    libtool \
    gettext \
    imagemagick \
    jq \
    htop \
    procps \
    shellcheck \
    yamllint \
    wget \
    curl \
    fuse3 \
    pipx \
    luarocks \
    unzip \
    libharfbuzz-dev \
    libicu-dev \
    liblcms2-dev \
    librsync-dev \
    libutf8proc-dev \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libbz2-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    gnupg \
    pinentry-curses \
    default-mysql-client \
    python3 \
    python3-pip \
    python3-venv \
    llvm \
    clang \
    lld \
    default-jdk
