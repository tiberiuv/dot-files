sh ./install_scripts/osx/macos_defaults.sh
sh ./install_scripts/osx/install_packages.sh
sh ./install_scripts/osx/create_symlinks.sh

# Use pinentry as key manager
echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent

sudo cp ./install_scripts/osx/com.startup.sysctl.plist /Library/LaunchDaemons/com.startup.sysctl.plist

chown root:wheel /Library/LaunchDaemons/com.startup.sysctl.plist
launchctl load /Library/LaunchDaemons/com.startup.sysctl.plist

sudo cp ./install_scripts/osx/limit.maxfiles.plist /Library/LaunchDaemons/limit.maxfiles.plist
chown root:wheel /Library/LaunchDaemons/limit.maxfiles.plist
launchctl load /Library/LaunchDaemons/limit.maxfiles.plist
