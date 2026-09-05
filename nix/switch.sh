#!/bin/sh
# Apply the home-manager configuration. Works from any cwd, with the checkout
# at any path, invoked directly or through a symlink on $PATH.
#
#   nix/switch.sh              apply
#   nix/switch.sh --dry-run    show what would change, touch nothing
#
set -eu

# `readlink -f` would be one line, but macOS's readlink has no -f.
resolve_symlinks() {
    _p=$1
    while [ -L "$_p" ]; do
        _d=$(dirname -- "$_p")
        _l=$(readlink -- "$_p")
        case $_l in
            /*) _p=$_l ;;
            *) _p=$_d/$_l ;;
        esac
    done
    printf '%s\n' "$_p"
}

_self=$(resolve_symlinks "$0")
# `pwd -P` resolves symlinked parents too: nix/links.nix points symlinks at
# this, and a symlink to a symlink is needless indirection to leave in ~.
DOTFILES_DIR=$(CDPATH='' cd -- "$(dirname -- "$_self")/.." && pwd -P)
export DOTFILES_DIR

if [ ! -f "$DOTFILES_DIR/flake.nix" ]; then
    echo "switch.sh: no flake.nix at $DOTFILES_DIR -- is this script still inside the checkout?" >&2
    exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
    echo "switch.sh: nix is not installed. Run \`. $DOTFILES_DIR/nix/bootstrap.sh\` first (source it -- it has to leave nix on PATH)." >&2
    exit 1
fi

# Normally set by the profile script, but this often runs from a shell that
# predates the install. flake.nix reads it.
if [ -z "${USER:-}" ]; then
    USER=$(id -un)
    export USER
fi

# nix.conf may not enable flakes on a stock install.
NIX="nix --extra-experimental-features nix-command --extra-experimental-features flakes"

# The home-manager pinned in flake.lock, not `nix run home-manager/master`,
# which fetches a second unpinned copy that can skew against these modules.
# --no-link keeps a `result` symlink out of the checkout.
target="$DOTFILES_DIR#homeConfigurations.default.activationPackage"

if [ "${1:-}" = "--dry-run" ]; then
    echo "==> evaluating $target"
    # shellcheck disable=SC2086
    out=$($NIX build --impure --no-link --print-out-paths "$target")
    echo "==> would activate: $out"
    if [ -e "$HOME/.local/state/nix/profiles/home-manager" ]; then
        echo "==> changes vs. current generation:"
        $NIX store diff-closures "$HOME/.local/state/nix/profiles/home-manager" "$out" || true
    fi
    exit 0
fi

echo "==> building home-manager generation from $DOTFILES_DIR"
# shellcheck disable=SC2086
out=$($NIX build --impure --no-link --print-out-paths "$target")

echo "==> activating $out"
"$out/activate"
