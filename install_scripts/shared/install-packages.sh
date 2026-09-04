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

# cargo-binstall fetches prebuilt release binaries instead of compiling from
# source, which turns the tool install below from ~15 minutes of rustc into a
# handful of downloads. Its own installer is a prebuilt binary too, so nothing
# here is compiled unless a crate publishes no binaries (binstall then falls
# back to `cargo install` on its own).
if ! command -v cargo-binstall >/dev/null 2>&1; then
    curl -L --proto '=https' --tlsv1.2 -sSf \
        https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
fi

# Install Rust cli tools.
#
# What used to be here -- eza, bat, procs, ripgrep, starship -- moved to
# nix/packages.nix. These three did not, and the reason is the same for all of
# them: they belong to the rustup toolchain rather than to the package set.
# trunk and wasm-bindgen-cli have to match the wasm32-unknown-unknown target
# added above, and fnm is a version manager, which is the one category this
# migration deliberately leaves alone.
#
# fnm comes from the QuickInstall build service rather than an upstream
# release. Add `--disable-strategies quick-install` to take only
# upstream-published binaries, at the cost of compiling it.
cargo binstall --no-confirm --locked \
  trunk \
  wasm-bindgen-cli \
  fnm
