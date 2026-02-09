#!/bin/sh

# Install tmux tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if ! which -s brew ; then
    # Install brew - package/app for osx
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

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

# Add wasm target for rust
rustup target add wasm32-unknown-unknown

# Install nvim plugins
nvim --headless "+Lazy! sync" +qa

### Install tmux tpm plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh

### Install zinit 
zinit update
