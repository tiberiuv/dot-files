#!/bin/bash

. ./install_scripts/shared/setup-dirs.sh
. ./install_scripts/shared/create_symlinks.sh
. ./install_scripts/debian/apt-install.sh
. ./install_scripts/shared/install-packages.sh
. ./install_scripts/debian/install_packages.sh

# Use pinentry-curses as the gpg passphrase prompt (mirrors pinentry-mac on osx)
if ! grep -qs pinentry-program ~/.gnupg/gpg-agent.conf; then
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    echo "pinentry-program $(command -v pinentry-curses)" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent 2>/dev/null
fi

# Install zinit - package manager for zsh shell
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# ~/.zshrc is zsh syntax and zinit is a shell function defined by it, so both of
# these need an *interactive* zsh: sourcing it from this bash script only
# produces a wall of syntax errors, and a non-interactive `zsh -c` never reads
# .zshrc at all.
zsh -i -c "zinit update" </dev/null

# Install nvim plugins and treesitter parsers. Runs last: it needs the C
# toolchain, node and tree-sitter-cli that the steps above install.
nvim --headless "+Lazy! sync" +qa

ZSH_PATH="$(command -v zsh)"
if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
    sudo chsh -s "$ZSH_PATH" "$USER"
fi
