# Read by every zsh, interactive or not, and this file is in place before
# install_scripts ever runs rustup -- so guard it, otherwise a fresh box gets
# "no such file or directory: ~/.cargo/env" on every single shell start.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Nix single-user profile. Guarded the same way as the cargo line above: this
# file is in place on machines where nix has not been installed yet, and an
# unguarded source would break every shell start on a fresh box.
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"

# home-manager's session variables (MANPATH, XDG_DATA_DIRS, NIX_PATH...).
# programs.zsh would normally emit these, but nix/home.nix deliberately leaves
# it disabled so ~/.zshrc stays a live-editable file in this repo rather than a
# generated one -- so they get sourced by hand here instead.
[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Deliberately sourced here, not in ~/.zshrc: everything .zshrc prepends
# afterwards -- the fnm/pyenv/mise shims and ~/.cargo/bin -- must keep winning
# for the toolchains those version managers own. The nix profile sits below
# them and above the system, which is the ordering the migration plan calls for.
