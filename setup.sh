#!/bin/bash
set -u

# One command, clean box to working shell.
#
# The shape after the nix migration is the same on both platforms:
#
#   1. OS prerequisites -- only what is needed to *reach* nix, plus the things
#      that genuinely cannot live in a user profile (the C toolchain, the
#      headers pyenv compiles CPython against, root-owned system config).
#   2. Bootstrap nix, if absent.
#   3. nix/switch.sh -- the package set and every dotfile symlink, in one step.
#      This is what used to be create_symlinks.sh plus most of four installers.
#   4. The version managers nix deliberately does not own: rustup, fnm, pyenv,
#      tfenv, mise. Plus tpm and zinit, which are plugin managers, not packages.
#   5. Root-owned OS leftovers, then nvim plugins last.
#
# Steps 1 and 5 are the only per-OS parts, so they are what the dispatch below
# selects. Everything in between is identical and lives in shared/.

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
