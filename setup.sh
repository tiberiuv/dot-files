#!/bin/bash
set -u

# One command, clean box to working shell. Both per-OS scripts have the same
# shape; only the prerequisites and the root-owned leftovers differ:
#
#   1. OS prerequisites -- only what is needed to reach nix, plus what cannot
#      live in a user profile (C toolchain, pyenv's headers, system config).
#   2. Bootstrap nix.
#   3. nix/switch.sh -- the package set and every dotfile symlink.
#   4. The version and plugin managers nix does not own.
#   5. Root-owned OS leftovers, then nvim plugins last.

# Every sub-script below refers to ./install_scripts/... relative to the repo
# root, so don't depend on the caller's cwd.
cd "$(dirname "$0")" || exit 1

OS=$(uname -s)

if [ "${OS}" = "Darwin" ] ; then
    zsh ./install_scripts/osx/setup.sh
elif [ "${OS}" = "Linux" ] ; then
    if [ -f /etc/debian_version ] ; then
        . ./install_scripts/debian/setup.sh
    else
        echo "Unsupported Linux distribution: only Debian/Ubuntu are handled." >&2
        exit 1
    fi
else
    echo "Unsupported OS: ${OS}" >&2
    exit 1
fi
