# Nix migration

Moving this repo off twelve overlapping package managers (apt, brew, rustup,
cargo-binstall, `go install`, `npm -g`, pipx, luarocks, coursier, poetry's
installer, and the pyenv/tfenv/fnm/mise family) onto one declarative package
set, on both macOS and Debian/Ubuntu.

Nix owns **packages** and **dotfile symlinks**. It deliberately does not own
language toolchains, macOS GUI apps, or the nvim/zsh plugin managers.

## Status

| Phase | What | State |
| --- | --- | --- |
| 0 | Bootstrap nix | done (this workspace) |
| 1 | flake + home-manager, packages only | done — `fd31190`, `4d6aa51` |
| 2 | Symlinks move to home-manager | done |
| 3 | Strip the imperative installers | done |
| 4 | `setup.sh` rewrite + Coder integration | done, except the Coder items |
| 5 | Optional: nix-darwin, devshells, nixvim | not started |

Apply with `nix/switch.sh` (or `nix/switch.sh --dry-run`). It works from any
working directory and with the checkout at any path.

## Running this

Clean box, one command:

```sh
./setup.sh
```

`nix` reaches `PATH` through `.zshenv`, which **non-interactive shells do not
read**. Any script or agent shell needs this first, or the very first `nix`
call fails with `command not found`:

```sh
. nix/bootstrap.sh          # installs nix if absent, no-op if not; SOURCE it
```

Apply a change:

```sh
nix/switch.sh              # build and activate
nix/switch.sh --dry-run    # build, print the closure diff, activate nothing
```

Move the pinned inputs forward (deliberately, never as a side effect):

```sh
nix flake update && nix/switch.sh --dry-run
```

**Validating without `/nix`.** `/nix` is not persistent here, so after a
workspace rebuild it may be gone. A sandboxed nix still parses and fully
evaluates the config with no root, no `/nix`, and no system changes:

```sh
curl -fsSL -o /tmp/nix-portable \
  "https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m)"
chmod +x /tmp/nix-portable
export DOTFILES_DIR="$(pwd -P)"

/tmp/nix-portable nix-instantiate --parse flake.nix nix/*.nix   # syntax only

/tmp/nix-portable nix --extra-experimental-features 'nix-command flakes' \
  eval --impure --raw '.#homeConfigurations.default.activationPackage.drvPath'
```

The second command resolves every package in the closure, so it catches a bad
attribute name before anything is downloaded. Prefix it with
`NIX_SYSTEM=aarch64-darwin` to evaluate the **macOS** configuration from Linux
— the only way to check that half from a Coder workspace.

Do not reach for `nixpkgs-fmt` as a syntax check: it silently accepts malformed
Nix. Use `nix-instantiate --parse`.


## Decisions already locked in

**The checkout is location-independent.** No canonical `~/dot-files`. A flake
cannot see its own working directory — `./.` evaluates to the read-only
`/nix/store` copy, which is exactly what `mkOutOfStoreSymlink` must not point
at — so `switch.sh` resolves itself through any symlink chain and exports
`DOTFILES_DIR`, which `flake.nix` reads alongside `HOME` and `USER`. That is
why `--impure` is required. It buys three strings; every package still resolves
against the revision pinned in `flake.lock`.

**Configs stay live-editable.** `nix/links.nix` uses `mkOutOfStoreSymlink`, so
`~/.zshrc` points back into the checkout: edits are instant and `git diff` still
works. `programs.zsh` / `programs.git` / `programs.tmux` stay disabled — they
would generate those files and fight the symlinks. The cost is that
`hm-session-vars.sh` has to be sourced by hand, which `.zshenv` now does.

**Version managers stay.** rustup, pyenv, tfenv, fnm and mise exist to switch
versions per project; Nix's answer to that is devshells, which is phase 5 at the
earliest. PATH ordering keeps their shims ahead of the nix profile:

```
fnm shims > pyenv shims > ~/.local/bin > ~/.cargo/bin > nix profile > /usr/bin
```

## Phase 2 — symlinks (done)

`dotfiles.manageLinks = true`; home-manager owns all 11 links, and
`create_symlinks.sh` and `setup-dirs.sh` are deleted. `setup-dirs.sh` went too
because home-manager creates the parent of every managed link — all of
`~/.config/{nvim,alacritty,kitty}` and `~/.claude` — and the only directory it
does not cover, `~/.tmux/plugins`, is created by the tpm `git clone` in
`shared/install-packages.sh`.

The old links had to be removed by hand first: home-manager refuses to clobber
files it did not create and aborts the activation listing each one. The survey
that produced the delete list, kept here because it is the safe way to repeat
this on another machine — it deletes **only** symlinks that point into the
checkout, and reports anything that is a real file instead:

```sh
ROOT=$(pwd -P)
nix eval --impure --raw ".#homeConfigurations.default.config.home.file" \
  --apply 'f: builtins.concatStringsSep "\n" (builtins.attrNames f)' \
| sed "s|^\([^/]\)|$HOME/\1|" \
| while IFS= read -r f; do
    if [ -L "$f" ]; then
      t=$(readlink "$f")
      case "$t" in
        "$ROOT"/*) echo "WOULD RM   $f -> $t" ;;
        *)         echo "KEEP(link) $f -> $t" ;;
      esac
    elif [ -e "$f" ]; then
      echo "KEEP(file) $f   <-- real file, not a link; investigate before touching"
    fi
  done
```

The listing includes home-manager's own generated files (`fontconfig`,
`environment.d`, `.keep`); the `$ROOT` guard correctly leaves those alone.
Expect exactly 11 `WOULD RM` lines. Swap the `echo` for `rm`, then
`nix/switch.sh`.

> **`~/.zshenv` is one of the 11.** Between the delete and a successful switch,
> new shells have neither nix nor cargo on PATH. If the switch fails in that
> window, `. ~/.nix-profile/etc/profile.d/nix.sh` restores nix by hand.

Verified after the switch: 11 links resolve into the checkout, and appending to
`.tmux.conf` in the repo is visible through `~/.tmux.conf` immediately.

## Phase 3 — strip the imperative installers (done)

**Done when:** the measurement below reports every tool under `NIX`, except the
deliberate exceptions — whatever the version managers own, and `fzf`.

**Order matters.** Per row: confirm the nix copy works, *then* delete the old
installer, *then* re-measure. Deleting first can strand you without a working
`ruff` or `kubectl` halfway through.

Re-run this after each removal. It is the definition of done. `env -i` matters
— measuring from an inherited PATH gives the wrong answer:

```sh
CMDS=$(tr '\n' ' ' <<'EOF'
bat eza fd fzf rg procs tree htop jq yq ijq jid wget curl unzip gpg magick diff-so-fancy
starship nvim tree-sitter lua-language-server bash-language-server docker-langserver
typescript-language-server tsc vscode-json-language-server yaml-language-server
ansible-language-server terraform-ls pyright shellcheck yamllint hadolint cspell
markdownlint-cli2 prettier prettierd eslint_d commitlint stylua luacheck tflint ruff
black isort flake8 ansible-lint pipenv poetry kubectl cs scala sbt scalafmt
EOF
)
env -i HOME="$HOME" USER="$USER" TERM=xterm SHELL="$(command -v zsh)" \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    zsh -i -c "for c in $CMDS; do printf '%s\t%s\n' \"\$c\" \"\$(command -v \$c 2>/dev/null || echo MISSING)\"; done" \
    </dev/null 2>/dev/null \
  | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g; s/\[?1042l//' \
  | awk -F'\t' '{ p=$2
      if      (p ~ /nix-profile/)     k="NIX"
      else if (p == "MISSING")        k="missing"
      else if (p ~ /\.cargo/)         k="cargo"
      else if (p ~ /fnm_multishells/) k="npm-global"
      else if (p ~ /coursier/)        k="coursier"
      else if (p ~ /zinit/)           k="zinit"
      else if (p ~ /luarocks/)        k="luarocks"
      else if (p ~ /go\/bin/)         k="go-install"
      else if (p ~ /\.local\/bin/)    k="local-bin"
      else                            k="system"
      a[k]=a[k]" "$1; n[k]++ }
    END { for (x in a) printf "%-11s %2d %s\n", x, n[x], a[x] }' | sort -k2 -rn
```

Keep `CMDS` on continuation lines exactly as above — an embedded newline lands
inside the `for ... ; do` and silently produces an empty result rather than an
error.

Before, immediately after phase 1 — 20 of 55 on nix:

```
NIX         20  fd tree htop jq yq ijq jid wget curl unzip gpg magick diff-so-fancy nvim
                terraform-ls pyright shellcheck yamllint tflint sbt
npm-global  14  tree-sitter bash-language-server docker-langserver typescript-language-server
                tsc vscode-json-language-server yaml-language-server ansible-language-server
                cspell markdownlint-cli2 prettier prettierd eslint_d commitlint
local-bin   11  lua-language-server hadolint ruff black isort flake8 ansible-lint pipenv
                poetry kubectl cs
cargo        6  bat eza rg procs starship stylua
coursier     2  scala scalafmt
zinit        1  fzf
luarocks     1  luacheck
```

After — 54 of 55, with the one intended exception:

```
NIX         54  bat eza fd rg procs tree htop jq yq ijq jid wget curl unzip gpg magick
                diff-so-fancy starship nvim tree-sitter lua-language-server
                bash-language-server docker-langserver typescript-language-server tsc
                vscode-json-language-server yaml-language-server ansible-language-server
                terraform-ls pyright shellcheck yamllint hadolint cspell markdownlint-cli2
                prettier prettierd eslint_d commitlint stylua luacheck tflint ruff black
                isort flake8 ansible-lint pipenv poetry kubectl cs scala sbt scalafmt
zinit        1  fzf
```

### What was retired, and how

Each row: the old installer line was deleted from the repo, then the installed
copy removed from this machine.

| Was winning from | Tools | Retired by |
| --- | --- | --- |
| `~/.cargo/bin` | bat, eza, rg, procs, starship, stylua | dropped from the `cargo binstall` list in `shared/install-packages.sh` and `update.zsh`; `cargo uninstall` each |
| npm globals (fnm) | tree-sitter, the six node language servers, tsc, cspell, markdownlint-cli2, prettier, prettierd, eslint_d, commitlint | the `npm install -g` block in **both** `install_packages.sh` files; `npm uninstall -g`. `yarn` is the only global left |
| `~/.local/bin` (pipx) | ruff, black, isort, flake8, ansible-lint, pipenv | the pipx block; `pipx uninstall-all` |
| `~/.local/bin` (curl) | poetry | the poetry curl-installer; `install.python-poetry.org \| python3 - --uninstall` |
| `~/.local/bin` (tarballs) | hadolint, kubectl, lua-language-server, cs | the download blocks **and the whole `case $(uname -m)` arch table** they existed to feed |
| coursier | scala, scalac, sbtn, scalafmt | the `cs install` line; `cs uninstall` |
| `~/.luarocks/bin` | luacheck | `luarocks install --local luacheck`; `luarocks remove --local` |
| `~/go/bin` | yq, ijq, jid, tflint, terraform-ls | those five `go install` lines. `multi-gitter` keeps its one — genuinely absent from nixpkgs |
| zinit | fzf | **kept.** zinit installs it with `--key-bindings --completion`, which writes `~/.fzf.zsh` and wires `^T`/`^R`; nixpkgs' fzf ships no shell integration and `programs.fzf` would generate shell init. `fzf` was dropped from `packages.nix` instead |

### The two config changes that had to land here

- **`go`** is in `packages.nix`, and **both** `GOROOT` exports are gone from
  `.zshrc` (`/usr/local/go` on Linux, `$HOMEBREW_PREFIX/opt/go/libexec` on
  macOS), along with `$GOROOT/bin` on PATH. The nix `go` finds its own root; a
  stale `GOROOT` produces "go: cannot find GOROOT directory".
- **`zsh`** is in `packages.nix` but is **not** the login shell. `chsh` to a
  `/nix` path loses you a login shell on a box where `/nix` fails to mount, so
  apt/brew zsh stays in `/etc/shells` and stays the shell `chsh` points at.

`SCALA_HOME`, `$HOME/.local/share/coursier/bin`, `$HOME/Library/Application
Support/Coursier/bin` and `$HOME/.luarocks/bin` came out of `.zshrc` too:
nothing installs into any of them any more.

`update-all` was hardcoded to `. ~/dot-files/update.zsh`, which contradicts the
location-independence decision above and was already broken in the Coder
workspace. It now derives the checkout from `%x` — the file zsh is sourcing,
i.e. `.zshrc` itself, which is a symlink into the repo.

### Where this deviates from the original sketch

The sketch said `apt-install.sh` would drop to build deps plus
`locales fuse3 ca-certificates sudo`, and `install_brew_packages.sh` to casks
only. Both were too aggressive: taken literally they delete tools that nothing
else installs. The rule actually applied was **remove exactly what nix now
provides, keep everything else**, so these stayed:

- `git`, `curl`, `zsh` — needed to *reach* nix (clone, download, log in). The
  nix copies win on PATH afterwards, which is intended.
- `default-jdk` — `.zshrc` exports `JAVA_HOME=/usr/lib/jvm/default-java`.
- `llvm`, `clang`, `lld`, `build-essential`, `pkg-config` — the C toolchain,
  deliberately never moved into the profile.
- `alacritty`, `fontconfig` — GUI terminal, and the `fc-cache`/`fc-list` that
  `fonts.fontconfig.enable` writes config for.
- `libpq-dev`, `default-libmysqlclient-dev`, `libxml2-dev`, `libxmlsec1-dev`,
  `default-mysql-client` — project-level Python build deps (psycopg2,
  mysqlclient, xmlsec). Not dotfiles, but nothing else installs them.
- On macOS, `fnm mise pyenv tfenv node yarn python` — the sketch's "casks only"
  would have left the version managers, which this migration explicitly keeps,
  with no installer at all. Plus `multi-gitter`, `mysql`, `watch`.

What *did* go from `apt-install.sh`: the whole Ubuntu-PPA-vs-Debian neovim
branch, and tmux git-lfs imagemagick jq htop shellcheck yamllint wget gnupg
pinentry-curses diff-so-fancy xclip wl-clipboard luarocks pipx, plus the neovim
build deps (cmake ninja-build automake autogen libtool gettext libharfbuzz-dev
libicu-dev liblcms2-dev librsync-dev libutf8proc-dev) that no longer have
anything to build.

**`update.zsh`** lost the `cargo binstall` refresh for the six retired tools
and gained `nix flake update` → `nix/switch.sh` → `nix-collect-garbage -d
--delete-older-than 14d`.

## Phase 4 — setup.sh and Coder (done; the Coder items are not)

**Done when:** a clean box reaches a working shell with one `./setup.sh`, and
`setup.sh` no longer installs any individual package.

`setup.sh` itself is now only the OS dispatch. Both per-OS scripts have the
same five-step shape, and steps 1 and 5 are the only parts that differ:

1. **OS prerequisites** — only what is needed to *reach* nix, plus what cannot
   live in a user profile: the C toolchain, pyenv's CPython build headers,
   root-owned system config. `apt-install.sh` on Debian;
   `install_brew_packages.sh` (via `install_packages.sh`) on macOS.
2. **`. nix/bootstrap.sh`** — installs nix if absent, no-op if not.
3. **`nix/switch.sh`** — the package set *and* every dotfile symlink, in one
   step. This is what used to be `create_symlinks.sh` plus most of four
   installers. It runs before anything else so `~/.zshrc` and
   `~/.config/nvim` exist by the time zinit and nvim run.
4. **Version and plugin managers** — the categories nix deliberately does not
   own: rustup (and the three rust tools tied to its toolchain), fnm, pyenv,
   tfenv, mise, plus tpm and zinit.
5. **Root-owned leftovers, then nvim last** — `chsh`, `gpg-agent.conf`,
   `locale-gen` on Debian; `macos_defaults.sh`, the two `launchd` plists and
   the `sudo_local` Touch ID edit on macOS. Then
   `nvim --headless "+Lazy! sync" +qa`, which needs everything above it.

### `nix/bootstrap.sh`

**Source it, do not run it** — its job is to leave `nix` on PATH for the rest
of `setup.sh`, and a child process cannot do that. Idempotent, so a second run
is a no-op and it is safe to source from an interactive shell.

Two install shapes, picked per platform:

- **Linux: single-user** (`--no-daemon`), because the Coder workspace has no
  systemd for `nix-daemon` to run under. Needs `/nix` to exist and be owned by
  the invoking user first — the installer will not create it without root.
- **macOS: multi-user** (`--daemon`). Single-user is not really supported there
  any more: `/nix` has to be a synthetic APFS volume, and only the daemon
  installer knows how to make one.

`--no-modify-profile` on both, because the installer appends to `~/.zshenv`,
which is a symlink into this repo — it would silently mutate a tracked file.
`.zshenv` sources the profile itself, and now tries **both** locations, since
the two install shapes put the script in different places under different
names.

Two traps worth keeping written down:

- **`nix.sh` is a silent no-op when `USER` is unset.** It wraps its whole body
  in `if [ -n "$HOME" ] && [ -n "$USER" ]`. The profile sources without error
  and `nix` is still not on PATH. A login shell sets `USER`; Coder's
  `dotfiles_uri`, a `RUN` line in a Dockerfile and `env -i` do not.
  `bootstrap.sh` and `switch.sh` both set it from `id -un` first.
- **`sh <(curl ...)`, which upstream documents, is a bash/zsh-ism.** These
  files are `/bin/sh`. `bootstrap.sh` downloads to a temp file and runs that.

Verify the chain from an environment with nothing in it:

```sh
env -i HOME="$HOME" PATH=/usr/bin:/bin sh -c '. ./nix/bootstrap.sh && ./nix/switch.sh --dry-run'
```

### `chsh` still points at the distro zsh

`packages.nix` installs zsh and it wins on PATH, but `install_scripts/debian/setup.sh`
deliberately hardcodes `/usr/bin/zsh` (falling back to `/bin/zsh`) rather than
using `command -v zsh`. A login shell under `/nix` stops existing the moment
`/nix` fails to mount, and a box you cannot log into is a bad trade for a newer
zsh.

### Coder: keeping the store across rebuilds

In a Coder workspace `/` is ephemeral and `$HOME` is a separate volume
(`/dev/homedata` here, 50G). The store is ~6.3G, so it fits with room to spare
— but it cannot simply be *moved* there.

**The store data can live in `$HOME`; the store prefix cannot.** Every binary
nix installs has `/nix/store/...` baked into its RPATHs, shebangs and ELF
interpreter, and `cache.nixos.org` serves artifacts built for that literal
path. Point nix at another root (`--store`, a relocated install) and nothing in
the binary cache matches, so the whole closure compiles from source. That is
the "Nix is slow" trap in the gotchas above, arrived at deliberately.

So relocate the storage and keep the prefix — bind mount one onto the other:

```sh
sudo mv /nix ~/.nix-store        # once, if a store already exists
sudo mkdir -p /nix
sudo mount --bind ~/.nix-store /nix
```

After that nix behaves completely normally: no wrapper, no `--store` flag, full
binary-cache compatibility. The nix database (`/nix/var/nix/db`) and the
profile generations live under `/nix` too, so they persist with it.

`nix/bootstrap.sh` performs this mount itself when `~/.nix-store` exists (or
`$DOTFILES_NIX_STORE` points elsewhere), which makes `./setup.sh` self-healing
after a rebuild. It is **opt-in by that directory existing** — on a laptop,
where `/nix` is a real directory on a disk that already persists, the guard
does nothing and says nothing. To opt in on a fresh box, `mkdir -p
~/.nix-store` before the first `./setup.sh` and nix installs straight onto the
persistent volume, with no 6.3G move ever needed.

It refuses rather than guesses in the one ambiguous case: `~/.nix-store` exists
*and* `/nix` is a non-empty directory that is not it. Mounting would silently
hide a real store, so it stops and says so.

The "is it already mounted?" test compares **device+inode** of `/nix` and the
persistent directory, not the mount table. "Is something mounted at `/nix`" is
the wrong question — a foreign or stale mount passes it and hands back a store
that is not the persistent one, silently. `/proc/self/mounts` cannot answer the
right question anyway: for a bind mount it records the device, not the source
path.

**The mount still belongs in the Coder template's startup script**, which runs
as root before the session. Mounts do not survive a rebuild, and the bootstrap
guard only fires when something runs `./setup.sh`. The guard is the fallback,
not the mechanism.

> With `/nix` empty (mount missing, or before the first setup) every tool in
> the profile vanishes. `.zshenv` is guarded and degrades to the system tools,
> and `chsh` deliberately points at `/usr/bin/zsh` rather than the nix one, so
> a login shell survives. Those two guards are load-bearing under this scheme.

Still open, and not fixable in this repo: Coder kills long-running
`dotfiles_uri` scripts. With a warm store a `switch` does no downloading and
takes seconds, so persistence largely defuses this — but the *first* run on a
brand new workspace is still well past any reasonable timeout. Running
`./setup.sh` by hand that once is the honest answer.

## Phase 5 — optional, later

- **nix-darwin** — replaces `macos_defaults.sh`, both `launchd` plists, and the
  `sudo_local` Touch ID edit with declarative config. Independently valuable.
- **devshells + direnv** — the correct Nix answer to pyenv/tfenv/fnm, but it
  means adding a `flake.nix` and `.envrc` to every project repo.
- **nixvim** — a full rewrite of `lua/`. Low value; lazy.nvim works and Nix
  already supplies the LSPs and `tree-sitter`.
- **`multi-gitter`** — genuinely absent from nixpkgs. Either keep the
  `go install` or write a ~12-line `buildGoModule` derivation in `nix/pkgs/`.
  `tfenv` is also absent, by design; it stays a `git clone`.

## Gotchas

- **Flakes only see git-tracked files.** `nix flake lock` fails with "does not
  contain a '/flake.nix' file" until new files are `git add`ed. The error does
  not hint at the cause.
- **Never use `pkgs` inside `imports`.** `imports = ... ++ lib.optional
  pkgs.stdenv.hostPlatform.isLinux ./linux.nix` is an infinite recursion:
  `pkgs` comes from the module system, and `imports` must resolve before any
  option evaluates. Import unconditionally and gate contents with `lib.mkIf`,
  as `linux.nix` and `darwin.nix` do.
- **`stdenv.isLinux` / `isDarwin` are deprecated** — use
  `stdenv.hostPlatform.*`.
- **Keep `flake.lock` on a revision Hydra has built.** Track the
  `nixos-unstable` branch head, not an arbitrary commit, or a `switch` starts
  compiling LLVM. This is the most common way people conclude "Nix is slow" —
  phase 1 pulled the whole closure from `cache.nixos.org` with zero local builds.
- **`/nix` grows without bound.** Every generation pins its closure. Add
  `nix-collect-garbage -d --delete-older-than 14d` to `update.zsh`.
- **Do not install `gcc`/`binutils` into the profile** while `go install`,
  `cargo build` and node-gyp still use system headers — that is the classic
  route to glibc/header mismatches.

## Rollback

`home-manager generations` lists every generation with its store path; run the
`activate` script inside an older one to go back. Phase 1 is additive — nothing
outside the nix profile and `.zshenv` was touched, and both `.zshenv` lines are
guarded, so removing `/nix` entirely reverts to the pre-migration behaviour.
