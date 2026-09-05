#!/bin/bash

# Non-interactive: `apt upgrade` without -y (and tzdata/keyboard prompts) will
# otherwise block the whole unattended setup waiting on stdin.
export DEBIAN_FRONTEND=noninteractive

sudo -E apt update
sudo -E apt upgrade -y

sudo -E apt install -y ca-certificates curl

# What nix cannot or must not provide:
#   - build-essential/pkg-config/llvm/clang/lld: the C toolchain. Kept out of
#     the nix profile on purpose -- `go install`, `cargo build` and node-gyp
#     compile against the system headers.
#   - the pyenv build deps: pyenv compiles CPython, so it needs the -dev
#     headers on the system, not in a profile.
#   - git, curl, zsh: needed to *reach* nix, and zsh is the login shell (chsh
#     to a /nix path loses you a shell the moment /nix fails to mount). The nix
#     copies win on PATH afterwards, which is intended.
#   - alacritty, fontconfig: GUI terminal, and the fc-cache/fc-list that
#     fonts.fontconfig.enable in nix/linux.nix writes config for.
#   - default-jdk: .zshrc exports JAVA_HOME=/usr/lib/jvm/default-java.
#   - the libpq/mysql/xml -dev headers: project-level Python build deps
#     (psycopg2, mysqlclient, xmlsec). Nothing else installs them.
PACKAGES="
    alacritty
    git
    zsh
    sudo
    build-essential
    pkg-config
    llvm
    clang
    lld
    default-jdk
    procps
    curl
    fuse3
    unzip
    fontconfig
    ncurses-term
    locales
    python3
    python3-dev
    python3-pip
    python3-venv
    zlib1g-dev
    libssl-dev
    libreadline-dev
    libbz2-dev
    libsqlite3-dev
    libncurses-dev
    xz-utils
    tk-dev
    libffi-dev
    liblzma-dev
    libpq-dev
    default-libmysqlclient-dev
    libxml2-dev
    libxmlsec1-dev
    default-mysql-client
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
