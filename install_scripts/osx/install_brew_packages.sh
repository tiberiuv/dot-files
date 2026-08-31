#!/bin/sh

# homebrew/cask is built into brew now, and homebrew/cask-versions was
# deprecated and its casks (temurin11, firefox@developer-edition) folded into
# homebrew/cask -- tapping either just errors out.
brew tap hashicorp/tap

# Instal brew gui apps
brew install --cask \
  firefox@developer-edition \
  temurin11 \
  docker \
  font-jetbrains-mono-nerd-font

brew install tmux --head
brew install kitty --head
brew link --overwrite gnupg

# Install brew packages
brew install \
  ImageMagick \
  alacritty \
  ansible-lint \
  autogen \
  automake \
  black \
  cmake \
  coreutils \
  cspell \
  curl \
  eslint_d \
  flake8 \
  fnm \
  fuse \
  gcc \
  gettext \
  git \
  git-lfs \
  gnupg \
  go \
  hadolint \
  harfbuzz \
  htop \
  icu4c \
  ijq \
  isort \
  jid \
  jq \
  kubectl \
  lcms2 \
  librsync \
  libtool \
  llvm \
  lua-language-server \
  luarocks \
  markdownlint-cli2 \
  mise \
  mysql \
  ninja \
  node \
  openssl \
  pinentry \
  pinentry-mac \
  pipenv \
  poetry \
  prettierd \
  pyenv \
  python \
  readline \
  ruff \
  scala \
  shellcheck \
  stylua \
  terraform-ls \
  tfenv \
  tflint \
  utf8proc \
  watch \
  wget \
  yaml-language-server \
  yamllint \
  yarn \
  yq \
  zlib \
  multi-gitter \
  pam-reattach \
  diff-so-fancy
