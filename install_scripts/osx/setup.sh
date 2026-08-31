#!/bin/zsh

zsh ./install_scripts/shared/setup-dirs.sh
zsh ./install_scripts/shared/create_symlinks.sh
zsh ./install_scripts/osx/macos_defaults.sh
zsh ./install_scripts/shared/install-packages.sh
zsh ./install_scripts/osx/install_packages.sh

# Use pinentry-mac as the gpg passphrase prompt (mirrors pinentry-curses on
# debian). The path was hardcoded to the Intel prefix, so this wrote a
# nonexistent binary on Apple Silicon; it also re-appended on every run and
# assumed ~/.gnupg already existed.
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

sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local
