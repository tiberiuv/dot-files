#!/bin/bash

# The version managers, the runtimes they hand out, and the one tool nixpkgs
# does not carry. Everything else is in nix/packages.nix.
# Mirrors install_scripts/osx/install_packages.sh.
#
# Not sourced into an interactive shell, so PATH additions needed by later
# steps are exported inline.

# setup.sh bootstraps nix before this, but does not leave it on PATH for a
# non-interactive bash, and ~/.zshenv is only read by zsh.
# shellcheck disable=SC1091
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
export PATH="$HOME/.nix-profile/bin:$PATH"

mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# Absent from nixpkgs. $GOPATH/bin is on PATH per .zshrc.
go install github.com/lindell/multi-gitter@latest

# fnm itself comes from cargo in shared/install-packages.sh. yarn is the only
# npm global; the rest are in nix/packages.nix, each wrapped with its own
# nodejs so they do not care which version fnm has active.
export PATH="$HOME/.cargo/bin:$PATH"
eval "$(fnm env)"
fnm install --lts
fnm use --install-if-missing lts-latest
eval "$(fnm env)"
npm install -g yarn

# lua/options.lua pins vim.g.python3_host_prog to ~/pynvim/bin/python, so the
# venv has to exist or every nvim start reports a broken python3 provider.
if [ ! -x "$HOME/pynvim/bin/python" ]; then
  python3 -m venv "$HOME/pynvim"
  "$HOME/pynvim/bin/pip" install --upgrade pip pynvim
fi

# pyenv
if [ ! -d "$HOME/.pyenv" ]; then
  curl -fsSL https://pyenv.run | bash
fi

# Upstream is tfutils/tfenv: the old kamatama41 repo redirects there, and
# github.com/tfenv/tfenv is a 404.
if [ ! -d "$HOME/.tfenv" ]; then
  git clone --depth 1 https://github.com/tfutils/tfenv.git ~/.tfenv
fi
export PATH="$HOME/.tfenv/bin:$PATH"
tfenv install latest
tfenv use latest

# mise owns lua itself; luacheck and luaformatter come from nix.
curl -fsSL https://mise.run | sh
mise plugins add --yes lua
mise use -g lua@5.1
