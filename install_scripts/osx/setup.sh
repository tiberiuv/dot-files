#!/bin/zsh

# ---- 2/3. nix ---------------------------------------------------------------
# First, unlike the Debian side: macOS ships curl and sudo, so nix needs no
# prerequisites, and the daemon installer wants to run before Homebrew starts
# competing for /usr/local. bootstrap.sh must be sourced -- it leaves nix on
# PATH for everything below. switch.sh then installs the package set *and*
# every dotfile symlink, so ~/.zshrc and ~/.config/nvim exist before zinit and
# nvim run at the bottom.
# shellcheck disable=SC1091
. ./nix/bootstrap.sh
./nix/switch.sh

# ---- 1. Prerequisites, and 4. version managers ------------------------------
# On macOS these are the same script: Homebrew supplies the C toolchain, the
# GUI casks, and the version managers (fnm, mise, pyenv, tfenv) in one go.
zsh ./install_scripts/osx/install_packages.sh

# rustup + the three rust tools tied to its toolchain, and tpm.
zsh ./install_scripts/shared/install-packages.sh

# ---- 5. Root-owned leftovers -----------------------------------------------
zsh ./install_scripts/osx/macos_defaults.sh

# Use pinentry-mac as the gpg passphrase prompt (mirrors pinentry-curses on
# debian). It comes from the nix profile now (nix/darwin.nix), so the hardcoded
# Intel-prefix path this used to have is gone for good. The guard stays because
# an empty pinentry-program line breaks gpg-agent outright, and because this
# would otherwise re-append on every run.
PINENTRY="$(command -v pinentry-mac)"
if [ -n "$PINENTRY" ] && ! grep -qs pinentry-program ~/.gnupg/gpg-agent.conf; then
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    echo "pinentry-program $PINENTRY" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent 2>/dev/null
fi

sudo cp ./install_scripts/osx/com.startup.sysctl.plist /Library/LaunchDaemons/com.startup.sysctl.plist

sudo chown root:wheel /Library/LaunchDaemons/com.startup.sysctl.plist
sudo launchctl load /Library/LaunchDaemons/com.startup.sysctl.plist

sudo cp ./install_scripts/osx/limit.maxfiles.plist /Library/LaunchDaemons/limit.maxfiles.plist
sudo chown root:wheel /Library/LaunchDaemons/limit.maxfiles.plist
sudo launchctl load /Library/LaunchDaemons/limit.maxfiles.plist

# Touch ID for sudo, including inside tmux (pairs with pam-reattach in
# nix/darwin.nix).
sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local

# Install zinit - package manager for zsh shell. Still the owner of fzf: it
# installs it with --key-bindings --completion, which writes ~/.fzf.zsh and
# wires ^T/^R. nixpkgs' fzf ships no shell integration, so `fzf` is
# deliberately absent from nix/packages.nix.
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# ~/.zshrc is zsh syntax and zinit is a shell function defined by it, so this
# needs an *interactive* zsh: a non-interactive `zsh -c` never reads .zshrc, so
# `zinit` would never be defined.
zsh -i -c "zinit update" </dev/null

# Install nvim plugins and treesitter parsers. Runs last: it needs the C
# toolchain from Homebrew and the tree-sitter CLI from the nix profile.
nvim --headless "+Lazy! sync" +qa
