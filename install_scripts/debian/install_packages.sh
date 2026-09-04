#!/bin/bash

# What is left after nix/packages.nix took over the package set: version
# managers, the node/python runtimes they hand out, and the one tool nixpkgs
# does not carry. Mirrors install_scripts/osx/install_packages.sh.
#
# Deleted in the nix migration (phase 3), for the record -- every one of these
# is now a line in nix/packages.nix:
#   - the neovim tarball, and with it the Ubuntu-PPA-vs-Debian branch
#   - the go.dev tarball into /usr/local/go (and the GOROOT export in .zshrc)
#   - `go install` of yq, ijq, jid, tflint, terraform-ls
#   - the kubectl, hadolint and lua-language-server release binaries
#   - the JetBrainsMono Nerd Font tarball (fonts.fontconfig.enable in
#     nix/linux.nix makes fc-list see the nix copy instead)
#   - the npm -g language servers, linters and formatters
#   - the pipx block and the poetry curl-installer
#   - the coursier bootstrap and `cs install`
#   - `cargo binstall stylua` and the luarocks packages
#
# That also took the whole `case $(uname -m)` architecture table with it: it
# existed only to pick per-arch download URLs, and nothing here downloads a
# release binary any more.
#
# Not sourced into an interactive shell, so PATH additions needed by later
# steps in this script are exported inline.

# go and friends live in the nix profile now. setup.sh bootstraps nix before
# reaching this script, but it does not leave it on PATH for a non-interactive
# bash, and ~/.zshenv (which does) is only read by zsh.
# shellcheck disable=SC1091
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
export PATH="$HOME/.nix-profile/bin:$PATH"

mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# multi-gitter is genuinely absent from nixpkgs, so it keeps its `go install`.
# The go doing the installing is the nix one; $GOPATH/bin is on PATH per .zshrc.
go install github.com/lindell/multi-gitter@latest

# fnm/node/npm (fnm itself installed via cargo in shared/install-packages.sh).
# yarn is the only global left: everything else that used to be installed here
# is in nix/packages.nix, wrapped with its own nodejs so it does not care which
# version fnm has active.
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

# tfenv (no apt package, and no nixpkgs package either -- version managers are
# out of scope for nixpkgs by design). Upstream is tfutils/tfenv -- the old
# kamatama41 repo redirects there, and github.com/tfenv/tfenv is a 404.
if [ ! -d "$HOME/.tfenv" ]; then
  git clone --depth 1 https://github.com/tfutils/tfenv.git ~/.tfenv
fi
export PATH="$HOME/.tfenv/bin:$PATH"
tfenv install latest
tfenv use latest

# mise + lua plugin. Still the owner of lua itself; luacheck and luaformatter
# moved to nix (the luaformatter binary is called lua-format).
curl -fsSL https://mise.run | sh
mise plugins add --yes lua
mise use -g lua@5.1
