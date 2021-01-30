mkdir ~/.config
mkdir ~/.config/nvim
mkdir ~/.config/nvim/lua
mkdir ~/.config/alacritty
mkdir ~/.tmux
mkdir ~/.tmux/plugins

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install brew - package/program manager for osx
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# install zinit - package manager for zsh shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap AdoptOpenJDK/openjdk

brew cask install vlc
brew cask install firefox-developer-edition
brew cask install spotify
brew cask install adoptopenjdk

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

yarn global add lua-fmt

luarocks install luacheck

cargo install exa bat procs ripgrep diesel_cli
