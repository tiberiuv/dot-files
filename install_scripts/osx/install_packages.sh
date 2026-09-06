#!/bin/sh

# setup.sh bootstraps nix before this, but does not leave it on PATH for a
# non-interactive /bin/sh, and ~/.zshenv is only read by zsh.
# shellcheck disable=SC1091
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
export PATH="$HOME/.nix-profile/bin:$PATH"

if ! which -s brew ; then
    # Install brew - package/app for osx
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [ "$(arch)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)";
else
  eval "$(/usr/local/bin/brew shellenv)";
fi

# Resolve relative to this script, not the caller's cwd: setup.sh runs it
# from the repo root, where ./install_brew_packages.sh does not exist.
SCRIPT_DIR="$(dirname "$0")"
. "$SCRIPT_DIR/install_brew_packages.sh"

tfenv install latest
tfenv init
tfenv use latest

mise plugins add lua
mise use -g lua@5.1
