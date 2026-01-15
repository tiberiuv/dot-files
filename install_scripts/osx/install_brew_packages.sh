# Add other repos to brew
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap hashicorp/tap

# Instal brew gui apps
brew install --cask \
  firefox@developer-edition \
  temurin11 \
  docker \
  font-jetbrains-mono-nerd-font

brew install tmux --head
brew install kitty --head
brew link --overwrite gnupg
brew install mise

# Install brew packages
brew install \
  ImageMagick \
  alacritty \
  ansible-lint \
  autogen \
  automake \
  cmake \
  coreutils \
  cspell \
  curl \
  dotnet-sdk \
  fnm \
  fuse \
  gcc \
  gettext \
  git \
  git-lfs \
  gnupg \
  go \
  hadolint \
  harfbuzz \
  htop \
  icu4c \
  ijq \
  jid \
  jq \
  kubectl \
  lcms2 \
  librsync \
  libtool \
  llvm \
  lua-language-server \
  markdownlint-cli2 \
  mise \
  mysql \
  ninja \
  node \
  openssl \
  pinentry \
  pinentry-mac \
  pipenv \
  poetry \
  prettierd \
  pyenv \
  python \
  readline \
  ruff \
  scala \
  shellcheck \
  terraform-ls \
  tfenv \
  tflint \
  tmux \
  utf8proc \
  watch \
  wget \
  yaml-language-server \
  yamllint \
  yarn \
  yq \
  zlib \
  multi-gitter
