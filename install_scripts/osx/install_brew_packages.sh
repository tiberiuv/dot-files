#!/bin/sh

# What Homebrew still owns; everything else is in nix/packages.nix.
#
#   1. GUI apps. Casks install real .app bundles with Dock/Spotlight/Launch
#      Services registration, which nix cannot do. alacritty and kitty do build
#      for darwin in nixpkgs, but integrate poorly enough that the formulae stay.
#   2. Version managers -- fnm, mise, pyenv, tfenv -- and the node/yarn they
#      hand out. Deliberately out of scope; see the migration notes.
#   3. The C toolchain and the headers pyenv compiles CPython against. A nix
#      toolchain in front of `go install` / `cargo build` / node-gyp is the
#      classic glibc/header mismatch.

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
