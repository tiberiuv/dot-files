#!/bin/sh

# What Homebrew still owns after the nix migration. nix/packages.nix took over
# the package set; three categories could not follow it:
#
#   1. GUI apps. Casks install real .app bundles with Dock/Spotlight/Launch
#      Services registration, which nix cannot do properly. alacritty and kitty
#      do build for darwin in nixpkgs, but the integration is poor enough that
#      the formulae stay.
#   2. Version managers -- fnm, mise, pyenv, tfenv -- and the node/yarn they
#      hand out. Deliberately out of scope; see the migration notes.
#   3. The C toolchain and the headers pyenv compiles CPython against. Putting
#      a nix toolchain in front of `go install` / `cargo build` / node-gyp is
#      the classic glibc/header mismatch.
#
# Everything else that used to be in this file is now a line in
# nix/packages.nix (or nix/darwin.nix, for pinentry-mac and pam-reattach):
# ImageMagick ansible-lint black cspell curl diff-so-fancy eslint_d flake8 git
# git-lfs gnupg go hadolint htop ijq isort jid jq kubectl lua-language-server
# luarocks markdownlint-cli2 pinentry pinentry-mac pipenv poetry prettierd ruff
# scala shellcheck stylua terraform-ls tflint tmux wget yaml-language-server
# yamllint yq -- plus font-jetbrains-mono-nerd-font, superseded by
# nerd-fonts.jetbrains-mono, and the neovim build deps (cmake ninja autogen
# automake libtool gettext harfbuzz icu4c lcms2 librsync utf8proc) that no
# longer have anything to build.

# homebrew/cask is built into brew now, and homebrew/cask-versions was
# deprecated and its casks (temurin11, firefox@developer-edition) folded into
# homebrew/cask -- tapping either just errors out.
brew tap hashicorp/tap

# GUI apps
brew install --cask \
  firefox@developer-edition \
  temurin11 \
  docker

brew install kitty --head
brew install alacritty

# Version managers, and the runtimes they distribute
brew install \
  fnm \
  mise \
  pyenv \
  tfenv \
  node \
  yarn \
  python

# C toolchain + pyenv's CPython build deps
brew install \
  coreutils \
  gcc \
  llvm \
  openssl \
  readline \
  zlib \
  fuse

# No nixpkgs package (verified), and things with no equivalent worth moving
brew install \
  multi-gitter \
  mysql \
  watch
