#!/bin/sh
# Install nix if absent. Idempotent.
#
#   . nix/bootstrap.sh
#
# SOURCE this. Its job is to leave `nix` on PATH for the caller, and a child
# process cannot do that.
#
# No `set -e`: sourced, so a stray non-zero exit would kill the caller's shell.

# nix.sh wraps its whole body in `if [ -n "$HOME" ] && [ -n "$USER" ]`, so with
# USER unset it sources cleanly and silently leaves nix off PATH. Login shells
# set USER; Coder's dotfiles_uri, a Dockerfile RUN and `env -i` do not.
if [ -z "${USER:-}" ]; then
    USER=$(id -un)
    export USER
fi

# Keeping the store across rebuilds, where / is ephemeral but $HOME is not.
#
# The store data can live in $HOME; the store prefix cannot. /nix/store/... is
# baked into every binary's RPATHs, shebangs and ELF interpreter, and
# cache.nixos.org serves artifacts built for that literal path -- point nix at
# another root and the whole closure compiles from source. So relocate the
# storage and bind mount it back onto the prefix.
#
# Opt in by creating the directory; silent otherwise, which is the laptop case.
# On a fresh box `mkdir -p ~/.nix-store` before ./setup.sh installs nix
# straight onto the persistent volume, so nothing ever needs moving.
#
# This is a fallback: mounts do not survive a rebuild, and this only fires when
# something runs ./setup.sh. The mount belongs in the Coder template's startup
# script, which runs as root before the session:
#
#   mkdir -p /nix
#   mountpoint -q /nix || mount --bind /home/<user>/.nix-store /nix
DOTFILES_NIX_STORE="${DOTFILES_NIX_STORE:-$HOME/.nix-store}"

_nix_store_is_persistent() {
    # Device+inode, not the mount table. "Is something mounted at /nix" is the
    # wrong question -- a foreign or stale mount passes it and silently yields a
    # store that is not the persistent one. /proc/self/mounts cannot answer the
    # right one anyway: a bind mount records the device, not the source path.
    _a=$(stat -c '%d:%i' /nix 2>/dev/null) || return 1
    _b=$(stat -c '%d:%i' "$DOTFILES_NIX_STORE" 2>/dev/null) || return 1
    [ -n "$_a" ] && [ "$_a" = "$_b" ]
}

_nix_bind_persistent_store() {
    # macOS has no `mount --bind`, and does not need one: the daemon installer
    # puts /nix on its own APFS volume, which already persists.
    [ "$(uname -s)" = "Linux" ] || return 0
    [ -d "$DOTFILES_NIX_STORE" ] || return 0

    if _nix_store_is_persistent; then
        unset _a _b
        return 0
    fi
    unset _a _b

    # Mounting would hide a real store. Only someone who knows which of the two
    # is current can resolve this.
    if [ -d /nix ] && [ -n "$(ls -A /nix 2>/dev/null)" ]; then
        echo "bootstrap: $DOTFILES_NIX_STORE exists, but /nix is a non-empty directory that is not mounted from it." >&2
        echo "bootstrap: refusing to mount over it. Merge or remove one of the two, then re-run." >&2
        return 1
    fi

    echo "bootstrap: mounting $DOTFILES_NIX_STORE at /nix"
    if [ ! -d /nix ]; then
        sudo mkdir -m 0755 /nix || return 1
    fi
    # Ownership follows the underlying filesystem, so no chown is needed after.
    if ! sudo mount --bind "$DOTFILES_NIX_STORE" /nix; then
        echo "bootstrap: bind mount failed. nix will still work, but /nix is not persistent." >&2
        return 1
    fi
}

_nix_bind_persistent_store

# Single-user puts the profile script in the user's profile; multi-user puts it
# in the system one under another name. Only ever one of the two exists.
_nix_load_profile() {
    for _s in "$HOME/.nix-profile/etc/profile.d/nix.sh" \
              /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; do
        if [ -f "$_s" ]; then
            # shellcheck disable=SC1090
            . "$_s"
        fi
    done
    unset _s
    # Sourcing always succeeds, even when it no-ops. Whether nix is callable is
    # the only honest test.
    command -v nix >/dev/null 2>&1
}

if _nix_load_profile; then
    echo "bootstrap: nix already installed ($(command -v nix))"
else
    echo "bootstrap: installing nix"

    # Upstream documents `sh <(curl ...)`, which is a bash/zsh-ism in a /bin/sh
    # file. Download, then run.
    _nix_installer=$(mktemp)
    if ! curl -fsSL https://nixos.org/nix/install -o "$_nix_installer"; then
        echo "bootstrap: could not download the nix installer" >&2
        rm -f "$_nix_installer"
        unset _nix_installer
        return 1 2>/dev/null || exit 1
    fi

    # --no-modify-profile on both: the installer appends to ~/.zshenv, which is
    # a symlink into this repo, so it would mutate a tracked file. ~/.zshenv
    # sources the profile itself.
    if [ "$(uname -s)" = "Darwin" ]; then
        # Multi-user on macOS: single-user needs /nix to be a synthetic APFS
        # volume, and only the daemon installer creates one.
        sh "$_nix_installer" --daemon --no-modify-profile
    else
        # Single-user on Linux: the Coder workspace has no systemd for
        # nix-daemon. Needs /nix to exist and be user-owned first.
        if [ ! -d /nix ]; then
            sudo mkdir -m 0755 /nix && sudo chown "$(id -u):$(id -g)" /nix
        fi
        sh "$_nix_installer" --no-daemon --no-modify-profile
    fi

    rm -f "$_nix_installer"
    unset _nix_installer

    # switch.sh passes --extra-experimental-features on every call, but a bare
    # `nix build` or `nix flake update` (update.zsh runs one) needs this.
    mkdir -p "$HOME/.config/nix"
    if ! grep -qs 'experimental-features' "$HOME/.config/nix/nix.conf"; then
        echo 'experimental-features = nix-command flakes' >> "$HOME/.config/nix/nix.conf"
    fi

    _nix_load_profile \
        || echo "bootstrap: nix installed, but not on PATH -- open a new shell" >&2
fi

unset -f _nix_load_profile _nix_store_is_persistent _nix_bind_persistent_store
