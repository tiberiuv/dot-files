#!/bin/bash

OS=$(uname -s)

if [ "${OS}" = "Darwin" ] ; then
    zsh ./install_scripts/osx/setup.sh
elif [ "${OS}" = "Linux" ] ; then
    KERNEL=`uname -r`
    if [ -f /etc/debian_version ] ; then
        . ./install_scripts/debian/setup.sh
    fi
fi
