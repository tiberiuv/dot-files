#!/bin/sh

# Run last, after nix/switch.sh has linked ~/.zshrc and ~/.config/nvim.

# ~/.zshrc clones zinit on first start, so this is its whole install. zinit
# also owns fzf: it installs it with --key-bindings --completion, which writes
# ~/.fzf.zsh and wires ^T/^R. Hence no fzf in nix/packages.nix.
#
# Needs an *interactive* zsh: ~/.zshrc is zsh syntax and zinit is a shell
# function defined by it, and a non-interactive `zsh -c` never reads .zshrc.
zsh -i -c "zinit update" </dev/null

# Needs the C toolchain (apt or Homebrew) and tree-sitter from the nix profile.
nvim --headless "+Lazy! sync" +qa
