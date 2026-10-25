#!/bin/bash
# Checks a built workspace image before CI moves `latest` onto it:
#
#   docker run --rm -v "$PWD/install_scripts/debian:/t:ro" dot-files-workspace bash /t/smoke-test.sh
#
# A missing apt package already fails the build (APT_STRICT); this covers what
# installing cleanly does not prove -- the user, sudo, the locale, and that
# the toolchain actually runs.
set -u

failed=0
check() {
    if "$@" >/dev/null 2>&1; then
        echo "ok   $*"
    else
        echo "FAIL $*"
        failed=1
    fi
}

check test "$(id -un)" = coder
check sudo -n true
check bash -c "locale -a | grep -qiE '^en_US\.utf-?8$'"

for cmd in git zsh curl unzip clang lld pkg-config make python3 mysql fc-list ping; do
    check command -v "$cmd"
done

check bash -c 'printf "int main(void){return 0;}" | clang -x c - -o /tmp/smoke && /tmp/smoke'
check python3 -m venv /tmp/smoke-venv
check ping -c 1 -W 2 127.0.0.1

exit "$failed"
