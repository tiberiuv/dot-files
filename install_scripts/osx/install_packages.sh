#!/bin/sh

mkdir -p ~/.config
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/alacritty
mkdir -p ~/.tmux
mkdir -p ~/.tmux/plugins

# Install tmux tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

which -s brew
if [[ $? != 0 ]] ; then
    # Install brew - package/app for osx
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

if [ "$(arch)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)";
else
  eval "$(/usr/local/bin/brew shellenv)";
fi

# Add other repos to brew
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap hashicorp/tap

# Instal brew gui apps
brew install --cask firefox@developer-edition temurin11 docker

brew install --cask font-jetbrains-mono-nerd-font

# Install brew packages
brew install llvm gcc wget curl watch pyenv autogen ninja libtool automake gettext git git-lfs tmux pipenv poetry python node yarn scala pinentry gnupg kubectl mysql htop openssl readline zlib coreutils cmake icu4c harfbuzz lcms2 fuse librsync ImageMagick utf8proc go terraform-ls ansible-lint yamllint yaml-language-server fnm pinentry-mac jq ijq jid yq shellcheck alacritty lua-language-server tflint tfenv dotnet-sdk mise markdownlint-cli2 prettierd ruff

brew install tmux --head
brew install kitty --head

brew link --overwrite gnupg

brew install mise

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
