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
  eval $(/opt/homebrew/bin/brew shellenv);
else
  eval $(/usr/local/bin/brew shellenv);
fi

# Install zinit - package manager for zsh shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# Add other repos to brew
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

# Instal brew gui apps
brew install --cask vlc
brew install --cask firefox-developer-edition
brew install --cask spotify
brew install --cask temurin11

# Install brew packages
brew install \
    llvm \
    gcc \ 
    wget \
    curl \
    watch \
    diff-so-fancy \
    pyenv \
    autogen \
    ninja \
    libtool \
    automake \
    pkg-config \
    gettext \
    git \
    docker \
    tmux \
    pipenv \
    python \
    node \
    yarn \
    scala \
    pinentry-mac \
    gnupg \
    gpg-agent \
    kubectl \
    mysql \
    postgres \
    htop \
    openssl \
    readline \
    zlib \
    coreutils \
    cmake \
    icu4c \
    harfbuzz \
    lcms2 \
    font-jetbrains-mono-nerd-font \
    fuse \
    librsync \
    ImageMagick

brew link --overwrite gnupg

# Install global node modules
# mainly linters etc.
yarn global add lua-fmt typescript-language-server pyright pyvm vscode-langservers-extracted

# Install Lua linter
luarocks install luacheck

# Install Rust cli tools
cargo install exa bat procs ripgrep diesel_cli trunk wasm-bindgen-cli

# Add wasm target for rust
rustup target add wasm32-unknown-unknown

curl -L -o coursier https://git.io/coursier-cli
chmod +x coursier
mv coursier ~/bin

# Install metals scala lsp server
./coursier bootstrap \
  --java-opt -Xss4m \
  --java-opt -Xms100m \
  --java-opt -Dmetals.client=vim-lsc \
  org.scalameta:metals_2.12:0.9.10 \
  -r bintray:scalacenter/releases \
  -r sonatype:snapshots \
  -o /usr/local/bin/metals-vim -f

mv /usr/local/bin/metals-vim /usr/local/bin/metals

# Install nvim plugins
nvim -c PackerInstall

### Install tmux tpm plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh

### Install zinit 
zinit update
