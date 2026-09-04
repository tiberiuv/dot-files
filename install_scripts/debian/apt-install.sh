#!/bin/bash

# Non-interactive: `apt upgrade` without -y (and tzdata/keyboard prompts) will
# otherwise block the whole unattended setup waiting on stdin.
export DEBIAN_FRONTEND=noninteractive

sudo -E apt update
sudo -E apt upgrade -y

sudo -E apt install -y ca-certificates curl

# The Ubuntu-PPA-vs-Debian branch that used to live here is gone: it existed
# solely to get a neovim newer than bookworm's 0.7, and neovim now comes from
# nix/packages.nix on both distros. So do jq, htop, tmux, git-lfs, imagemagick,
# wget, gnupg, diff-so-fancy, xclip, wl-clipboard, luarocks, pinentry-curses,
# and the shellcheck/yamllint pair -- along with the neovim build deps (cmake,
# ninja-build, automake, autogen, libtool, gettext, libharfbuzz-dev,
# libicu-dev, liblcms2-dev, librsync-dev, libutf8proc-dev) that no longer have
# anything to build. pipx went with the pipx block in install_packages.sh.
#
# What is left is what nix does not, or must not, provide:
#   - build-essential/pkg-config/llvm/clang/lld: the C toolchain. Deliberately
#     NOT moved into the nix profile -- `go install`, `cargo build` and
#     node-gyp compile against the system headers, and mixing a nix toolchain
#     into that is the classic glibc/header mismatch.
#   - the pyenv build deps: pyenv compiles CPython, so it needs the -dev
#     headers on the system, not in a profile.
#   - git, curl, zsh: needed to *reach* nix. git clones this repo, curl runs
#     the installer, and zsh is the login shell -- `chsh` to a /nix path is
#     how you lose a shell on a box where /nix fails to mount. The nix copies
#     of all three win on PATH afterwards; that is fine and intended.
#   - alacritty and fontconfig: GUI terminal, plus the fc-cache/fc-list that
#     `fonts.fontconfig.enable` in nix/linux.nix writes config for.
#   - default-jdk: .zshrc exports JAVA_HOME=/usr/lib/jvm/default-java.
#   - the libpq/mysql/xml -dev headers: project-level Python build deps
#     (psycopg2, mysqlclient, xmlsec). Not dotfiles, but nothing else installs
#     them, so dropping them silently breaks pip installs.
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
