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

# Install zinit - package manager for zsh shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# Add other repos to brew
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap AdoptOpenJDK/openjdk

# Instal brew gui apps
brew cask install vlc
brew cask install firefox-developer-edition
brew cask install spotify
brew cask install adoptopenjdk

# Install brew packages
brew install
    llvm \
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
    pinentry \
    pinentry-mac \
    gnupg \
    gpg \
    gpg2 \
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
    liblcms2 \
    lcms2

brew link --overwrite gnupg


# Install global node modules
# mainly linters etc.
yarn global add lua-fmt typescript-language-server pyright

# Install Lua linter
luarocks install luacheck

# Install Rust cli tools
cargo install exa bat procs ripgrep diesel_cli

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
nvim -c PlugInstall

### Install tmux tpm plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh
