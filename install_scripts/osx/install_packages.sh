#!/bin/sh

# nvim and the tooling below come from the nix profile. setup.sh bootstraps nix
# before reaching this script, but does not leave it on PATH for a
# non-interactive /bin/sh, and ~/.zshenv (which does) is only read by zsh.
# shellcheck disable=SC1091
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
export PATH="$HOME/.nix-profile/bin:$PATH"

if ! which -s brew ; then
    # Install brew - package/app for osx
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [ "$(arch)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)";
else
  eval "$(/usr/local/bin/brew shellenv)";
fi

# Resolve relative to this script, not the caller's cwd: setup.sh runs it
# from the repo root, where ./install_brew_packages.sh does not exist.
SCRIPT_DIR="$(dirname "$0")"
. "$SCRIPT_DIR/install_brew_packages.sh"

tfenv install latest
tfenv init
tfenv use latest

mise plugins add lua
mise use -g lua@5.1

# The npm -g block that used to be here -- commitlint, the node language
# servers, tree-sitter-cli -- is in nix/packages.nix now, wrapped with its own
# nodejs so it does not care which version brew's node is on. yarn stays a brew
# formula (see install_brew_packages.sh).

# lua/options.lua pins vim.g.python3_host_prog to ~/pynvim/bin/python, so the
# venv has to exist or every nvim start reports a broken python3 provider.
if [ ! -x "$HOME/pynvim/bin/python" ]; then
  python3 -m venv "$HOME/pynvim"
  "$HOME/pynvim/bin/pip" install --upgrade pip pynvim
fi

# Install zinit - package manager for zsh shell
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# ~/.zshrc is zsh syntax and zinit is a shell function defined by it, so both
# of these need an *interactive* zsh: sourcing it from this /bin/sh script only
# produces a wall of syntax errors, and `zinit` is never defined here.
zsh -i -c "zinit update" </dev/null

# Install nvim plugins and treesitter parsers. Runs last: it needs the
# toolchain, node and tree-sitter-cli that the steps above install.
nvim --headless "+Lazy! sync" +qa
