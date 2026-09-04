#!/bin/sh
# Apply the home-manager configuration.
#
# Works from any working directory, and with the checkout at any path -- run it
# as ./nix/switch.sh, /abs/path/to/nix/switch.sh, or through a symlink parked
# somewhere on $PATH. Everything it needs is derived from its own location.
#
#   nix/switch.sh              apply
#   nix/switch.sh --dry-run    show what would change, touch nothing
#
set -eu

# Resolve $0 through any chain of symlinks. `readlink -f` would be one line,
# but macOS's readlink has no -f, and this repo has to run on both.
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
# `pwd -P` resolves symlinked parent directories too, so DOTFILES_DIR is always
# the real path on disk. nix/links.nix points symlinks at it, and a symlink to
# a symlink to the checkout would be a needless indirection to leave in ~.
DOTFILES_DIR=$(CDPATH='' cd -- "$(dirname -- "$_self")/.." && pwd -P)
export DOTFILES_DIR

if [ ! -f "$DOTFILES_DIR/flake.nix" ]; then
    echo "switch.sh: no flake.nix at $DOTFILES_DIR -- is this script still inside the checkout?" >&2
    exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
    echo "switch.sh: nix is not installed. See the phase 0 bootstrap in the migration notes." >&2
    exit 1
fi

# Set by the installer's profile script, but this script is often run from a
# shell that predates the install.
if [ -z "${USER:-}" ]; then
    USER=$(id -un)
    export USER
fi

# Both flags are needed on a stock install: nix.conf may not enable flakes, and
# the config reads HOME/USER/DOTFILES_DIR from the environment (see flake.nix).
NIX="nix --extra-experimental-features nix-command --extra-experimental-features flakes"

# Build with the home-manager pinned in flake.lock rather than `nix run
# home-manager/master`, which would fetch a second, unpinned copy and can skew
# against the module set this config was written for.
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
