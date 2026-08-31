# Read by every zsh, interactive or not, and this file is in place before
# install_scripts ever runs rustup -- so guard it, otherwise a fresh box gets
# "no such file or directory: ~/.cargo/env" on every single shell start.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
