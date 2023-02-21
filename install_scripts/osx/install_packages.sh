mkdir ~/.config
mkdir ~/.config/nvim
mkdir ~/.config/nvim/lua
mkdir ~/.config/alacritty
mkdir ~/.tmux
mkdir ~/.tmux/plugins

# Install tmux tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install brew - package/app for osx
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

if [ "$(arch)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)";
else
  eval "$(/usr/local/bin/brew shellenv)";
fi

# Add other repos to brew
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts
brew tap hashicorp/tap

# Instal brew gui apps
brew install --cask firefox-developer-edition temurin11 docker

# Install brew packages
brew install llvm gcc wget curl watch pyenv autogen ninja libtool automake gettext git git-lfs tmux pipenv poetry python node yarn scala pinentry gnupg kubectl mysql postgres htop openssl readline zlib coreutils cmake icu4c harfbuzz lcms2 fuse librsync ImageMagick utf8proc go luarocks terraform-ls ansible-lint yamllint fnm pinentry-mac jq ijq jid yq shellcheck

brew install tmux --head
brew install kitty --head

brew link --overwrite gnupg

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
  bash-language-server

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
nvim -c PackerInstall

### Install tmux tpm plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh

### Install zinit 
zinit update
