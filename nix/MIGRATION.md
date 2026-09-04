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
| 2 | Symlinks move to home-manager | not started |
| 3 | Strip the imperative installers | not started |
| 4 | `setup.sh` rewrite + Coder integration | not started |
| 5 | Optional: nix-darwin, devshells, nixvim | not started |

Apply with `nix/switch.sh` (or `nix/switch.sh --dry-run`). It works from any
working directory and with the checkout at any path.

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

## Phase 2 — symlinks

1. Delete the symlinks `create_symlinks.sh` made. Home-manager refuses to
   clobber files it did not create, by design, and will abort the activation
   listing each one.
2. Set `dotfiles.manageLinks = true` in `nix/home.nix`.
3. `nix/switch.sh`, then confirm all 11 links resolve into the checkout.
4. Delete `install_scripts/shared/create_symlinks.sh` and drop its `.` line
   from both `setup.sh` files. `setup-dirs.sh` can go too, but check it first:
   home-manager creates the parent of every *managed link*, which covers all of
   `~/.config/{nvim,alacritty,kitty}` and `~/.claude` — but not
   `~/.tmux/plugins`, which exists for tpm. That one is created by the
   `git clone` in `shared/install-packages.sh` anyway, so the file should still
   be deletable; verify on a clean box rather than assuming.

`nix/links.nix` already mirrors `create_symlinks.sh` exactly; it was evaluated
with `manageLinks = true` during phase 1 and every target pointed at the
checkout. This phase is just flipping it on.

## Phase 3 — strip the imperative installers

This is where the payoff lands. Everything below is currently installed twice:
once by Nix, once by the old script, with the old copy still winning on PATH.
Measured from a clean login after phase 1:

| Still winning from | Tools | Retire by |
| --- | --- | --- |
| `~/.cargo/bin` | bat, eza, rg, procs, starship, stylua | drop from the `cargo binstall` list in `shared/install-packages.sh` and `update.zsh`, then `cargo uninstall` each |
| npm globals (fnm) | tree-sitter, bash-language-server, docker-langserver, typescript-language-server, tsc, vscode-json-language-server, yaml-language-server, ansible-language-server, cspell, markdownlint-cli2, prettier, prettierd, eslint_d, commitlint | delete the `npm install -g` block in **both** `install_packages.sh` files |
| `~/.local/bin` (pipx) | ruff, black, isort, flake8, ansible-lint, pipenv, poetry | delete the pipx block and the poetry curl-installer, then `pipx uninstall-all` |
| `~/.local/bin` (tarballs) | hadolint, kubectl, lua-language-server, cs | delete the download blocks **and the whole `case $(uname -m)` arch table** they exist to feed |
| coursier | scala, scalafmt | delete the `cs install` line |
| `~/.luarocks/bin` | luacheck | delete `luarocks install --local luacheck` |
| zinit | fzf | decide — see below |

Then:

- **`apt-install.sh`** drops to roughly: `build-essential pkg-config` plus the
  pyenv build deps (`libssl-dev libbz2-dev libreadline-dev libsqlite3-dev
  libffi-dev liblzma-dev tk-dev zlib1g-dev xz-utils`) plus `locales fuse3
  ca-certificates sudo`. **The entire Ubuntu-PPA-vs-Debian branch disappears**,
  because neovim now comes from Nix — that alone removes the `NEOVIM_PKG`
  conditional, the `add-apt-repository` call, and the upstream tarball fallback.
- **`install_brew_packages.sh`** drops to casks only:
  `firefox@developer-edition`, `temurin11`, `docker`, plus `alacritty` and
  `kitty` (nixpkgs builds those for darwin, but Dock/Spotlight integration is
  poor). `font-jetbrains-mono-nerd-font` is superseded by
  `nerd-fonts.jetbrains-mono`.
- **`update.zsh`** loses the `cargo binstall` refresh line and gains
  `nix flake update && nix/switch.sh` plus a `nix-collect-garbage` call.

Two config changes have to land in the same phase, because packages depend on
them:

- **`go`**: add to `packages.nix` *and* delete `export GOROOT=/usr/local/go`
  from `.zshrc`. Doing one without the other leaves `go` and `GOROOT`
  disagreeing.
- **`zsh`**: safe to install, but do **not** `chsh` to the nix one while `/nix`
  is a mountable volume that can fail to appear — that locks you out of a login
  shell. apt/brew zsh stays the login shell.

**Open decision — fzf.** zinit installs it with `--key-bindings --completion`,
which wires `^T`/`^R` and the completion hooks that `.zshrc` depends on. Nix's
fzf does not. Either keep zinit as the owner and drop `fzf` from
`packages.nix`, or move to home-manager's `programs.fzf` — but that generates
shell init, which is the thing phase 1 deliberately avoided. Leaning towards
dropping it from `packages.nix`.

## Phase 4 — setup.sh and Coder

`setup.sh` collapses to roughly: bootstrap nix if absent → `nix/switch.sh` →
the OS-specific leftovers that genuinely need root or are not packages
(macOS `launchd` plists, `macos_defaults.sh`, `sudo_local`; Debian
`locale-gen`, `chsh`, the `gpg-agent.conf` pinentry line) → `nvim --headless
"+Lazy! sync" +qa`.

Bootstrap, for reference — this is what was run in phase 0:

```sh
sudo mkdir -m 0755 /nix && sudo chown "$(id -u):$(id -g)" /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon --no-modify-profile
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

Single-user (`--no-daemon`) because the Coder workspace has no systemd.
`--no-modify-profile` because the installer appends to `~/.zshenv`, which is a
symlink into this repo — it would silently mutate a tracked file. `.zshenv`
sources the profile itself instead.

**Coder specifics, unresolved:**

- `/nix` is **not on a persistent volume yet**. It is ~6.0G (148 binaries in
  the profile) and is lost on every workspace rebuild. The guards in `.zshenv` mean a
  rebuilt workspace degrades cleanly back to the old tools rather than
  erroring, but the store has to be refetched.
- A persistent volume only helps from the *second* rebuild onward. The real fix
  is baking a pre-warmed `/nix` into the workspace image, which also sidesteps
  the next point.
- Coder kills long-running `dotfiles_uri` scripts. Even with a warm store the
  first `switch` is minutes; from cold it is well past any reasonable timeout.

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
