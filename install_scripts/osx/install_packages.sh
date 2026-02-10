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

. ./install_brew_packages.sh

tfenv install latest
tfenv init
tfenv use latest

mise plugins add lua
mise use -g lua@5.1

# Dotnet lsp server
dotnet tool install --global csharp-ls

# Install zinit - package manager for zsh shell
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

. ~/.zshrc

# Install global node modules
# mainly linters etc.
yarn global add \
  lua-fmt \
  typescript-language-server \
  pyright \
  pyvm \
  vscode-langservers-extracted \
  diagnostic-languageserver \
  stylelint \
  dockerfile-language-server-nodejs \
  vim-language-server \
  @ansible/ansible-language-server \
  bash-language-server \
  @commitlint/cli \
  @commitlint/config-conventional

# Install Lua linter
luarocks install luacheck luaformatter

# Install Rust cli tools
cargo install \
  exa \
  bat \
  procs \
  ripgrep \
  diesel_cli \
  trunk \
  wasm-bindgen-cli \
  fnm \
  starship

# Install nvim plugins
nvim --headless "+Lazy! sync" +qa

### Install zinit 
zinit update
