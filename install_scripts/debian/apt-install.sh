#!/bin/bash

# Non-interactive: `apt upgrade` without -y (and tzdata/keyboard prompts) will
# otherwise block the whole unattended setup waiting on stdin.
export DEBIAN_FRONTEND=noninteractive

sudo -E apt update
sudo -E apt upgrade -y

# add-apt-repository ships in software-properties-common, which is absent from
# minimal/cloud images, so install it before reaching for a PPA.
sudo -E apt install -y software-properties-common ca-certificates gnupg curl

# PPAs are Ubuntu-only. Debian gets a current neovim from the upstream release
# tarball in install_packages.sh instead (bookworm's apt neovim is 0.7, far too
# old for this config: blink.cmp and nvim-treesitter `main` need 0.11+).
DISTRO_ID="$(. /etc/os-release && echo "$ID")"
if [ "$DISTRO_ID" = "ubuntu" ]; then
    sudo -E add-apt-repository -y ppa:neovim-ppa/unstable
    sudo -E apt update
    NEOVIM_PKG=neovim
else
    NEOVIM_PKG=""
fi

PACKAGES="
    $NEOVIM_PKG
    tmux
    alacritty
    git
    git-lfs
    zsh
    build-essential
    pkg-config
    cmake
    ninja-build
    automake
    autogen
    libtool
    gettext
    imagemagick
    jq
    htop
    procps
    shellcheck
    yamllint
    wget
    curl
    fuse3
    pipx
    luarocks
    unzip
    fontconfig
    xclip
    wl-clipboard
    libharfbuzz-dev
    libicu-dev
    liblcms2-dev
    librsync-dev
    libutf8proc-dev
    zlib1g-dev
    libssl-dev
    libreadline-dev
    libbz2-dev
    libsqlite3-dev
    libpq-dev
    default-libmysqlclient-dev
    libncurses-dev
    ncurses-term
    xz-utils
    tk-dev
    libxml2-dev
    libxmlsec1-dev
    libffi-dev
    liblzma-dev
    gnupg
    pinentry-curses
    default-mysql-client
    diff-so-fancy
    locales
    python3
    python3-dev
    python3-pip
    python3-venv
    llvm
    clang
    lld
    default-jdk
"

# One unavailable package name would otherwise abort the entire list, so retry
# per package and report what could not be installed instead of dying.
# shellcheck disable=SC2086
if ! sudo -E apt install -y $PACKAGES; then
    echo "Batch apt install failed; retrying package by package." >&2
    for pkg in $PACKAGES; do
        sudo -E apt install -y "$pkg" || echo "apt: could not install $pkg" >&2
    done
fi

# .zshrc exports LANG/LC_ALL=en_US.UTF-8, but Debian/Ubuntu cloud and container
# images ship only C.UTF-8. Without generating it every shell start (and perl,
# git, tmux...) warns "setting locale failed".
if command -v locale-gen >/dev/null 2>&1 && ! locale -a 2>/dev/null | grep -qiE '^en_US\.?(utf-?8)$'; then
    grep -qs '^en_US.UTF-8 UTF-8' /etc/locale.gen \
        || echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen >/dev/null
    sudo -E locale-gen en_US.UTF-8
fi
