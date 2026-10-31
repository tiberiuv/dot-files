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
. ./install_scripts/shared/install-ai-tools.sh

# ---- 5. Root-owned leftovers -----------------------------------------------
# ~/.gnupg/gpg-agent.conf is nix/gpg.nix's now, written by switch.sh above.

# chsh refuses any shell missing from /etc/shells, and a container image often
# does not list zsh. Hardcoded to the apt zsh, not `command -v zsh` which would
# now find the nix one: a login shell under /nix stops existing the moment /nix
# fails to mount.
#
# Compared against the passwd entry, not $SHELL: that may be unset (Coder's
# dotfiles_uri, `env -i`), which kills this under setup.sh's `set -u`, and it
# keeps the old shell after a chsh until the next login.
ZSH_PATH=""
for candidate in /usr/bin/zsh /bin/zsh; do
    [ -x "$candidate" ] && ZSH_PATH="$candidate" && break
done
if [ -n "$ZSH_PATH" ] && [ "$(getent passwd "$USER" | cut -d: -f7)" != "$ZSH_PATH" ]; then
    grep -qxs "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    sudo chsh -s "$ZSH_PATH" "$USER"
fi

. ./install_scripts/shared/install-plugins.sh
