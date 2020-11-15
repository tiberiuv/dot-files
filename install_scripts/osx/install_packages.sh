# install brew - package/program manager for osx
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# install zinit - package manager for zsh shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

brew tap caskroom/cask
brew tap caskroom/versions
brew tap AdoptOpenJDK/openjdk

brew cask install vlc
brew cask install minikube
brew cask install firefox-developer-edition
brew cask install spotify
brew cask install adoptopenjdk

brew install git
brew install docker
brew install tmux
brew install pipenv
brew install python
brew install node
brew install yarn
brew install exa
brew install bat
brew install procs
brew install htop
brew install scala
