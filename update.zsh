#!/bin/zsh

# Meant to be *sourced* from an interactive zsh (`alias update-all` does this):
# zinit is a shell function defined by ~/.zshrc, not a binary, so running this
# file directly would skip the zinit steps.

[[ ${commands[rustup]} ]] && rustup update

if [[ $(uname -s) == "Darwin" ]]; then
  # Update Homebrew (Cask) & packages
  brew update
  brew upgrade
  brew upgrade --cask
else
  # Debian/Ubuntu equivalents of the brew block above
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  [[ ${commands[mise]} ]] && mise upgrade
fi

# `nix flake update` moves the pinned revisions forward -- without it a switch
# just rebuilds the same closure. Then drop old generations: each pins its
# whole closure, so /nix grows without bound otherwise.
#
# Sourced, so $0 is this file; :A:h gives the checkout wherever it lives.
if [[ ${commands[nix]} ]]; then
  nix flake update --flake ${0:A:h}
  ${0:A:h}/nix/switch.sh
  nix-collect-garbage -d --delete-older-than 14d
fi

# The rust tools tied to the rustup toolchain; binstall does not self-update.
[[ ${commands[cargo-binstall]} ]] && cargo binstall --no-confirm --locked \
  trunk wasm-bindgen-cli fnm

# Update yarn packages
[[ ${commands[yarn]} ]] && yarn global upgrade

# Update zinit & packages
if (( ${+functions[zinit]} )); then
  zinit self-update
  zinit update
else
  echo "zinit not loaded: source this file from an interactive zsh (update-all)." >&2
fi

# Update nvim plugins
[[ ${commands[nvim]} ]] && nvim --headless "+Lazy! sync" +qa
