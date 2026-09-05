#!/bin/zsh

# ---- 2/3. nix ---------------------------------------------------------------
# First, unlike Debian: macOS ships curl and sudo, so nix needs no
# prerequisites, and the daemon installer wants to run before Homebrew competes
# for /usr/local. bootstrap.sh must be sourced -- it leaves nix on PATH for
# everything below. switch.sh creates the dotfile symlinks too, so ~/.zshrc and
# ~/.config/nvim exist before zinit and nvim run at the bottom.
# shellcheck disable=SC1091
. ./nix/bootstrap.sh
./nix/switch.sh

# ---- 1. Prerequisites, and 4. version managers ------------------------------
# One script on macOS: Homebrew supplies the C toolchain, the GUI casks and the
# version managers together.
zsh ./install_scripts/osx/install_packages.sh
zsh ./install_scripts/shared/install-packages.sh

# ---- 5. Root-owned leftovers -----------------------------------------------
zsh ./install_scripts/osx/macos_defaults.sh

# Guarded because an empty pinentry-program line breaks gpg-agent outright,
# and because this would otherwise re-append on every run.
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

# Touch ID for sudo, including inside tmux (pairs with pam-reattach).
sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local

# zinit also owns fzf: it installs it with --key-bindings --completion, which
# writes ~/.fzf.zsh and wires ^T/^R. Hence no fzf in nix/packages.nix.
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Needs an *interactive* zsh: a non-interactive `zsh -c` never reads .zshrc, so
# the zinit function would never be defined.
zsh -i -c "zinit update" </dev/null

# Last: needs the C toolchain from Homebrew and tree-sitter from nix.
nvim --headless "+Lazy! sync" +qa
