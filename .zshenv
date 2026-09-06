# Read by every zsh, interactive or not, and in place before install_scripts
# ever runs rustup -- so guard it, or a fresh box gets an error every shell
# start. Same for the nix lines below.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# mosh-server refuses to start without a UTF-8 locale, and is launched over a
# non-interactive ssh that never reads ~/.zshrc. Defaulted, not assigned, so a
# locale the client forwarded still wins.
export LANG=${LANG:-en_US.UTF-8}
export LC_ALL=${LC_ALL:-en_US.UTF-8}

# Two paths because there are two install shapes (see nix/bootstrap.sh):
# single-user puts the script in the user's profile, multi-user in the system
# one under another name. Only one ever exists.
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] \
  && . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# home-manager's session variables (MANPATH, XDG_DATA_DIRS, NIX_PATH...).
# programs.zsh would emit these, but nix/home.nix leaves it off so ~/.zshrc
# stays live-editable -- so they are sourced by hand here.
[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Here, not in ~/.zshrc, so that everything .zshrc prepends afterwards -- the
# fnm/pyenv/mise shims and ~/.cargo/bin -- keeps winning for the toolchains
# those version managers own. The nix profile sits below them, above the system.
