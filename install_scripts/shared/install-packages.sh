#!/bin/sh

# Install tmux tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if "test ! -d ~/.tmux/plugins/tpm"; then \
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
fi

# Install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add wasm target for rust
rustup target add wasm32-unknown-unknown

# Install Rust cli tools
cargo install \
  exa \
  bat \
  procs \
  ripgrep \
  diesel_cli \
  trunk \
  wasm-bindgen-cli \
  fnm \
  starship

# Install nvim plugins
nvim --headless "+Lazy! sync" +qa
