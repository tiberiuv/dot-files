mkdir ~/.config
mkdir ~/.config/nvim
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
brew cask install cmake

brew install minikube \
    llvm \
    wget \
    curl \
    watch \
    diff-so-fancy \
    pyenv \
    autogen \
    install \
    clang \
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

brew link --overwrite gnupg
