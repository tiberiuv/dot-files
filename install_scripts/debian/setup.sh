#!/bin/bash

# ---- 1. Prerequisites -------------------------------------------------------
. ./install_scripts/debian/apt-install.sh

# ---- 2/3. nix ---------------------------------------------------------------
# bootstrap.sh must be sourced -- it leaves nix on PATH for everything below.
# switch.sh creates the dotfile symlinks too, so ~/.zshrc and ~/.config/nvim
# exist before zinit and nvim run at the bottom.
# shellcheck disable=SC1091
. ./nix/bootstrap.sh
./nix/switch.sh

# ---- 4. Version and plugin managers ----------------------------------------
. ./install_scripts/shared/install-packages.sh
. ./install_scripts/debian/install_packages.sh

# ---- 5. Root-owned leftovers -----------------------------------------------
# Guarded because an empty pinentry-program line breaks gpg-agent outright,
# and because this would otherwise re-append on every run.
PINENTRY="$(command -v pinentry-curses)"
if [ -n "$PINENTRY" ] && ! grep -qs pinentry-program ~/.gnupg/gpg-agent.conf; then
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    echo "pinentry-program $PINENTRY" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent 2>/dev/null
fi

# chsh refuses any shell missing from /etc/shells, and a container image often
# does not list zsh. Hardcoded to the apt zsh, not `command -v zsh` which would
# now find the nix one: a login shell under /nix stops existing the moment /nix
# fails to mount.
ZSH_PATH=""
for candidate in /usr/bin/zsh /bin/zsh; do
    [ -x "$candidate" ] && ZSH_PATH="$candidate" && break
done
if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
    grep -qxs "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    sudo chsh -s "$ZSH_PATH" "$USER"
fi

# zinit also owns fzf: it installs it with --key-bindings --completion, which
# writes ~/.fzf.zsh and wires ^T/^R. Hence no fzf in nix/packages.nix.
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# ~/.zshrc is zsh syntax and zinit is a shell function defined by it, so both of
# these need an *interactive* zsh: sourcing it from this bash script only
# produces a wall of syntax errors, and a non-interactive `zsh -c` never reads
# .zshrc at all.
zsh -i -c "zinit update" </dev/null

# Last: needs the C toolchain from step 1 and tree-sitter from the nix profile.
nvim --headless "+Lazy! sync" +qa
