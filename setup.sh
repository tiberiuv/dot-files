#!/bin/bash
set -u

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
