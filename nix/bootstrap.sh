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

# -----------------------------------------------------------------------------
# Keeping the store on a persistent volume (Coder, and anywhere else / is
# ephemeral but $HOME is not).
# -----------------------------------------------------------------------------
# The store *data* can live in $HOME. The store *prefix* cannot: every binary
# nix installs has /nix/store/... baked into its RPATHs, shebangs and ELF
# interpreter, and cache.nixos.org serves artifacts built for that literal
# path. Point nix at another root and nothing in the binary cache matches any
# more, so the entire closure compiles from source -- which is the "nix is
# slow" trap the migration notes warn about. So: relocate the storage, keep the
# prefix, bind mount the one onto the other.
#
# Opt in by creating the directory (or setting DOTFILES_NIX_STORE); this does
# nothing at all otherwise, because on a normal machine /nix is simply a real
# directory on a disk that already persists.
#
#   sudo mv /nix ~/.nix-store          # once, if a store already exists
#   mkdir -p ~/.nix-store              # or just this, before the first setup
#
# The mount belongs in the Coder template's startup script, which runs as root
# before the session. This is the fallback for when that is missing or has not
# run yet: it makes ./setup.sh self-healing after a workspace rebuild.
DOTFILES_NIX_STORE="${DOTFILES_NIX_STORE:-$HOME/.nix-store}"

_nix_store_is_persistent() {
    # Compare device+inode rather than reading the mount table. "Is something
    # mounted at /nix" is the wrong question -- a foreign mount, or a stale one
    # from a different store, would pass it and hand back a store that is not
    # the persistent one, silently. Two paths with the same device and inode
    # are the same directory, which is exactly the property being asserted, and
    # it holds however the mount was made. /proc/self/mounts cannot answer this
    # anyway: for a bind mount it records the device, not the source path.
    _a=$(stat -c '%d:%i' /nix 2>/dev/null) || return 1
    _b=$(stat -c '%d:%i' "$DOTFILES_NIX_STORE" 2>/dev/null) || return 1
    [ -n "$_a" ] && [ "$_a" = "$_b" ]
}

_nix_bind_persistent_store() {
    # macOS has no `mount --bind`, and does not need this: the daemon installer
    # puts /nix on its own synthetic APFS volume, which already persists.
    [ "$(uname -s)" = "Linux" ] || return 0

    # Not opted in. Silence is correct here -- this is the laptop case.
    [ -d "$DOTFILES_NIX_STORE" ] || return 0

    # Already the persistent store. Nothing to do, and nothing to say.
    if _nix_store_is_persistent; then
        unset _a _b
        return 0
    fi
    unset _a _b

    # A real store already sits at /nix and is not the one we were asked to
    # mount. Mounting over it would hide it, so refuse and say so: only the
    # person who knows which of the two is current can resolve this.
    if [ -d /nix ] && [ -n "$(ls -A /nix 2>/dev/null)" ]; then
        echo "bootstrap: $DOTFILES_NIX_STORE exists, but /nix is a non-empty directory that is not mounted from it." >&2
        echo "bootstrap: refusing to mount over it. Merge or remove one of the two, then re-run." >&2
        return 1
    fi

    echo "bootstrap: mounting $DOTFILES_NIX_STORE at /nix"
    if [ ! -d /nix ]; then
        sudo mkdir -m 0755 /nix || return 1
    fi
    # Ownership follows the underlying filesystem, so /nix ends up owned by
    # whoever owns $DOTFILES_NIX_STORE -- which is what a single-user install
    # needs, and why no chown is required afterwards.
    if ! sudo mount --bind "$DOTFILES_NIX_STORE" /nix; then
        echo "bootstrap: bind mount failed. nix will still work, but /nix is not persistent." >&2
        return 1
    fi
}

_nix_bind_persistent_store

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

unset -f _nix_load_profile _nix_store_is_persistent _nix_bind_persistent_store
