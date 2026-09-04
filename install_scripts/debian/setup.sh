#!/bin/bash

# Directories and dotfile symlinks are home-manager's now (nix/links.nix); it
# creates the parent of every managed link. ~/.tmux/plugins is the one
# exception, and the tpm `git clone` in shared/install-packages.sh makes it.
. ./install_scripts/debian/apt-install.sh
. ./install_scripts/shared/install-packages.sh
. ./install_scripts/debian/install_packages.sh

# Use pinentry-curses as the gpg passphrase prompt (mirrors pinentry-mac on osx).
# Guarded on the binary actually existing: apt-install.sh tolerates a failed
# package, and an empty pinentry-program line breaks gpg-agent outright.
PINENTRY="$(command -v pinentry-curses)"
if [ -n "$PINENTRY" ] && ! grep -qs pinentry-program ~/.gnupg/gpg-agent.conf; then
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    echo "pinentry-program $PINENTRY" >> ~/.gnupg/gpg-agent.conf
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

# chsh refuses any shell missing from /etc/shells, and zsh installed outside
# the distro package (or into a fresh container image) is often not listed.
ZSH_PATH="$(command -v zsh)"
if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
    grep -qxs "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    sudo chsh -s "$ZSH_PATH" "$USER"
fi
