#!/bin/sh

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

# Not available as brew formulae with the config package nvim-lint needs
npm install -g @commitlint/cli @commitlint/config-conventional

# Install zinit - package manager for zsh shell
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

. ~/.zshrc

# Install Lua linter
luarocks install luacheck luaformatter


# Install nvim plugins
nvim --headless "+Lazy! sync" +qa

### Install zinit 
zinit update
