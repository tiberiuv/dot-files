#!/bin/sh

# Install tmux tpm
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# Install rustup
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y

# rustup's installer only edits the shell rc files; this shell still has no
# cargo/rustup on PATH, so every command below would fail without sourcing it.
# shellcheck disable=SC1091
. "$HOME/.cargo/env"

# Add wasm target for rust
rustup target add wasm32-unknown-unknown

# Install Rust cli tools
# eza replaces exa: exa is unmaintained and no longer builds on current rustc.
cargo install \
  eza \
  bat \
  procs \
  ripgrep \
  diesel_cli \
  trunk \
  wasm-bindgen-cli \
  fnm \
  starship
