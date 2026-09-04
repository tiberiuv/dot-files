#!/bin/sh
# Install nix, if it is not already there. Idempotent: a second run is a no-op.
#
#   . nix/bootstrap.sh
#
# SOURCE this, do not execute it. The whole point is to leave `nix` on PATH for
# the caller, and a child process cannot do that. Running it directly still
# installs nix correctly, it just will not help the shell that ran it.
#
# Deliberately NOT the same thing as nix/switch.sh: this only gets the package
# manager onto the box. switch.sh applies this repo's configuration, and is the
# command you want for every change after the first.

# No `set -e`: this file is sourced, so a stray non-zero exit would kill the
# caller's shell rather than this script.

# nix.sh wraps its entire body in `if [ -n "$HOME" ] && [ -n "$USER" ]`, so it
# is a silent no-op when USER is unset -- the profile sources cleanly and `nix`
# is still not on PATH. A login shell sets USER; an unattended runner (Coder's
# dotfiles_uri, a Dockerfile RUN, `env -i`) frequently does not. switch.sh
# guards the same way, for the same reason.
if [ -z "${USER:-}" ]; then
    USER=$(id -un)
    export USER
fi

# Single-user (--no-daemon) puts the profile script in the user's own profile;
# multi-user puts it in the system profile under a different name. macOS gets a
# daemon install here and Linux does not, so both paths have to be tried.
_nix_load_profile() {
    for _s in "$HOME/.nix-profile/etc/profile.d/nix.sh" \
              /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; do
        if [ -f "$_s" ]; then
            # shellcheck disable=SC1090
            . "$_s"
        fi
    done
    unset _s
    # Sourcing a profile script always succeeds, even when it no-ops. The only
    # honest test of whether this worked is whether nix is now callable.
    command -v nix >/dev/null 2>&1
}

if _nix_load_profile; then
    echo "bootstrap: nix already installed ($(command -v nix))"
else
    echo "bootstrap: installing nix"

    # `sh <(curl ...)` is what upstream documents, but process substitution is a
    # bash/zsh-ism and this file is /bin/sh. Download first, then run.
    _nix_installer=$(mktemp)
    if ! curl -fsSL https://nixos.org/nix/install -o "$_nix_installer"; then
        echo "bootstrap: could not download the nix installer" >&2
        rm -f "$_nix_installer"
        unset _nix_installer
        return 1 2>/dev/null || exit 1
    fi

    # --no-modify-profile on both branches: the installer appends to ~/.zshenv,
    # and that file is a symlink into this repo (nix/links.nix), so it would
    # silently mutate a tracked file. ~/.zshenv sources the profile itself.
    if [ "$(uname -s)" = "Darwin" ]; then
        # macOS gets the stock multi-user install. Single-user is not really
        # supported there any more: /nix has to be a synthetic APFS volume, and
        # only the daemon installer knows how to create one.
        sh "$_nix_installer" --daemon --no-modify-profile
    else
        # Single-user on Linux, because the Coder workspace this was developed
        # in has no systemd for nix-daemon to run under. That needs /nix to
        # exist and be owned by the invoking user first -- the installer will
        # not create it without root.
        if [ ! -d /nix ]; then
            sudo mkdir -m 0755 /nix && sudo chown "$(id -u):$(id -g)" /nix
        fi
        sh "$_nix_installer" --no-daemon --no-modify-profile
    fi

    rm -f "$_nix_installer"
    unset _nix_installer

    # In nix.conf rather than as a flag: switch.sh passes
    # --extra-experimental-features on every call so it works without this, but
    # a bare interactive `nix build` or `nix flake update` needs it enabled
    # persistently. update.zsh runs exactly that.
    mkdir -p "$HOME/.config/nix"
    if ! grep -qs 'experimental-features' "$HOME/.config/nix/nix.conf"; then
        echo 'experimental-features = nix-command flakes' >> "$HOME/.config/nix/nix.conf"
    fi

    _nix_load_profile \
        || echo "bootstrap: nix installed, but not on PATH -- open a new shell" >&2
fi

unset -f _nix_load_profile
