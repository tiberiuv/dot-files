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

# npm-only tooling: commitlint's shareable config has no brew formula, and
# these language servers (enabled in lua/lsp/init.lua) aren't packaged either.
# vscode-langservers-extracted provides html/cssls/jsonls.
npm install -g \
  @commitlint/cli \
  @commitlint/config-conventional \
  bash-language-server \
  dockerfile-language-server-nodejs \
  typescript-language-server \
  typescript \
  vscode-langservers-extracted \
  @ansible/ansible-language-server \
  tree-sitter-cli

# lua/options.lua pins vim.g.python3_host_prog to ~/pynvim/bin/python, so the
# venv has to exist or every nvim start reports a broken python3 provider.
if [ ! -x "$HOME/pynvim/bin/python" ]; then
  python3 -m venv "$HOME/pynvim"
  "$HOME/pynvim/bin/pip" install --upgrade pip pynvim
fi

# Install zinit - package manager for zsh shell
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# ~/.zshrc is zsh syntax and zinit is a shell function defined by it, so both
# of these need an *interactive* zsh: sourcing it from this /bin/sh script only
# produces a wall of syntax errors, and `zinit` is never defined here.
zsh -i -c "zinit update" </dev/null

# Install Lua linter
luarocks install luacheck luaformatter

# Install nvim plugins and treesitter parsers. Runs last: it needs the
# toolchain, node and tree-sitter-cli that the steps above install.
nvim --headless "+Lazy! sync" +qa
