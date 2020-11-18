sh ./install_scripts/osx/install_packages.sh
sh ./install_scripts/osx/macos_defaults.sh
sh ./install_scripts/osx/create_symlinks.sh

echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent
