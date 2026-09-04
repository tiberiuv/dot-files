#!/bin/bash

# ---- 1. Prerequisites -------------------------------------------------------
# Only what nix cannot provide or must not provide: the C toolchain, pyenv's
# CPython build headers, root-owned system config, and the git/curl/zsh needed
# to reach nix in the first place. See the file itself for the full reasoning.
. ./install_scripts/debian/apt-install.sh

# ---- 2/3. nix ---------------------------------------------------------------
# bootstrap.sh must be sourced -- it leaves nix on PATH for everything below.
# switch.sh then installs the package set *and* every dotfile symlink, so
# ~/.zshrc and ~/.config/nvim exist before zinit and nvim run at the bottom.
# shellcheck disable=SC1091
. ./nix/bootstrap.sh
./nix/switch.sh

# ---- 4. Version and plugin managers ----------------------------------------
# rustup + the three rust tools tied to its toolchain, and tpm.
. ./install_scripts/shared/install-packages.sh
# fnm/node/yarn, pyenv, tfenv, mise, the pynvim venv, and multi-gitter.
. ./install_scripts/debian/install_packages.sh

# ---- 5. Root-owned leftovers -----------------------------------------------
# Use pinentry-curses as the gpg passphrase prompt (mirrors pinentry-mac on
# osx). It comes from the nix profile now (nix/linux.nix); the guard stays
# because an empty pinentry-program line breaks gpg-agent outright.
PINENTRY="$(command -v pinentry-curses)"
if [ -n "$PINENTRY" ] && ! grep -qs pinentry-program ~/.gnupg/gpg-agent.conf; then
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    echo "pinentry-program $PINENTRY" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent 2>/dev/null
fi

# chsh refuses any shell missing from /etc/shells, and zsh installed outside
# the distro package (or into a fresh container image) is often not listed.
#
# Deliberately the *apt* zsh, not the nix one, even though nix installs zsh and
# it wins on PATH: a login shell under /nix stops existing the moment /nix
# fails to mount, and a box you cannot log into is a bad trade for a newer zsh.
ZSH_PATH=""
for candidate in /usr/bin/zsh /bin/zsh; do
    [ -x "$candidate" ] && ZSH_PATH="$candidate" && break
done
if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
    grep -qxs "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    sudo chsh -s "$ZSH_PATH" "$USER"
fi

# Install zinit - package manager for zsh shell. Still the owner of fzf: it
# installs it with --key-bindings --completion, which writes ~/.fzf.zsh and
# wires ^T/^R. nixpkgs' fzf ships no shell integration, so `fzf` is
# deliberately absent from nix/packages.nix.
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# ~/.zshrc is zsh syntax and zinit is a shell function defined by it, so both of
# these need an *interactive* zsh: sourcing it from this bash script only
# produces a wall of syntax errors, and a non-interactive `zsh -c` never reads
# .zshrc at all.
zsh -i -c "zinit update" </dev/null

# Install nvim plugins and treesitter parsers. Runs last: it needs the C
# toolchain from step 1 and the tree-sitter CLI from the nix profile.
nvim --headless "+Lazy! sync" +qa
