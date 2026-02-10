#!/bin/sh

# Install tmux tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Install tmux tpm plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add wasm target for rust
rustup target add wasm32-unknown-unknown

# Install nvim plugins
nvim --headless "+Lazy! sync" +qa
