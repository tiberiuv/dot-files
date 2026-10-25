#!/bin/bash

# Non-interactive: `apt upgrade` without -y (and tzdata/keyboard prompts) will
# otherwise block the whole unattended setup waiting on stdin.
export DEBIAN_FRONTEND=noninteractive

sudo -E apt update
sudo -E apt upgrade -y

# Set by the image build only: a workstation keeps Recommends.
APT_FLAGS="-y"
[ -n "${APT_NO_RECOMMENDS:-}" ] && APT_FLAGS="$APT_FLAGS --no-install-recommends"

# shellcheck disable=SC2086
sudo -E apt install $APT_FLAGS ca-certificates curl

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
#   - iputils-ping: the store cannot hold setuid or file-capability binaries,
#     so a nix ping only works where ping_group_range allows unprivileged
#     ICMP -- and, being first on PATH, would shadow this one where it does not.
#   - mtr-tiny, traceroute, tcpdump, nmap: the same raw-socket problem, and
#     the root-only modes are run through sudo, whose secure_path never sees
#     the nix profile. Unprivileged network tools are in nix.
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
    procps
    iputils-ping
    mtr-tiny
    traceroute
    tcpdump
    nmap
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

# No display to draw on: an image build, a Coder workspace, a server. The
# catch is a desktop box set up over ssh without X forwarding, which skips it
# too.
if [ -z "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
    # shellcheck disable=SC2086
    PACKAGES=$(printf '%s\n' $PACKAGES | grep -vx alacritty)
fi

# One unavailable package name would otherwise abort the entire list, so retry
# per package and report what could not be installed instead of dying.
# shellcheck disable=SC2086
if ! sudo -E apt install $APT_FLAGS $PACKAGES; then
    echo "Batch apt install failed; retrying package by package." >&2
    for pkg in $PACKAGES; do
        # shellcheck disable=SC2086
        if ! sudo -E apt install $APT_FLAGS "$pkg"; then
            echo "apt: could not install $pkg" >&2
            apt_failed="${apt_failed:-}$pkg "
        fi
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

# Set by the image build, where a missing package must fail the build rather
# than ship. Off by default: setup.sh sources this file, so the exit would take
# setup.sh down with it.
if [ -n "${APT_STRICT:-}" ] && [ -n "${apt_failed:-}" ]; then
    echo "apt: failed to install: $apt_failed" >&2
    exit 1
fi
