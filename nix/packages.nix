# The package set that replaces the hand-rolled installers.
#
# Every attribute below was checked against the nixos-unstable package index
# before being written down; the handful of tools nixpkgs does not carry are
# listed at the bottom with what still installs them.
#
# Replaced (phase 3):
#   install_scripts/shared/install-packages.sh   (the cargo-binstall list)
#   install_scripts/debian/install_packages.sh   (~90% of it)
#   install_scripts/debian/apt-install.sh        (everything not a build dep)
#   install_scripts/osx/install_brew_packages.sh (everything but the casks)
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Core CLI --------------------------------------------------------
    # eza, bat, procs, ripgrep and starship used to be cargo-binstall'd into
    # ~/.cargo/bin, which sits earlier in PATH; phase 3 dropped them from
    # shared/install-packages.sh, so the nix copies are the only ones now.
    #
    # fzf is deliberately absent: zinit installs it with --key-bindings
    # --completion, which writes ~/.fzf.zsh and wires ^T/^R. nixpkgs' fzf ships
    # no shell integration, and home-manager's programs.fzf would generate
    # shell init -- the thing this config avoids. zinit stays fzf's owner.
    bat
    eza
    fd
    ripgrep
    procs
    tree
    htop
    jq
    yq-go
    ijq
    jid
    wget
    curl
    unzip
    gnupg
    imagemagick
    diff-so-fancy
    starship

    # --- Editor ----------------------------------------------------------
    # Biggest single win: this deleted the entire Ubuntu-PPA-vs-Debian-tarball
    # branch in apt-install.sh and install_packages.sh. tree-sitter is the CLI
    # nvim-treesitter's `main` branch shells out to when building parsers.
    neovim
    tree-sitter

    # --- Language servers ------------------------------------------------
    # All the npm-distributed ones are wrapped with their own nodejs, so they
    # work regardless of which node fnm has active.
    lua-language-server
    bash-language-server
    dockerfile-language-server # npm package is ...-nodejs; nixpkgs drops the suffix
    typescript-language-server
    typescript
    vscode-langservers-extracted # html, cssls, jsonls, eslint
    yaml-language-server
    ansible-language-server
    terraform-ls
    pyright

    # --- Linters & formatters --------------------------------------------
    shellcheck
    yamllint
    hadolint
    cspell
    markdownlint-cli2
    prettier
    prettierd
    eslint_d
    commitlint
    stylua
    luajitPackages.luacheck
    luaformatter
    tflint
    ruff
    black
    isort
    python3Packages.flake8
    ansible-lint

    # --- Python tooling ---------------------------------------------------
    # Standalone wrapped entry points -- they do not shadow pyenv's python.
    pipenv
    poetry

    # --- Kubernetes -------------------------------------------------------
    kubectl

    # --- Scala ------------------------------------------------------------
    # Replaced the coursier bootstrap + `cs install`, which install_packages.sh
    # deliberately avoided running as `cs setup` because that rewrites ~/.zshrc.
    coursier
    scala
    sbt
    scalafmt

    # --- Toolchains and base tools ---------------------------------------
    # go: replaces the go.dev tarball into /usr/local/go on Linux and `brew
    # install go` on macOS. GOROOT is now unset on purpose -- the go binary
    # finds its own -- and .zshrc no longer exports it; setting it to a stale
    # /usr/local/go while running the nix go is how you get "go: cannot find
    # GOROOT directory".
    go

    # zsh: on PATH, but NOT the login shell. `chsh` to a /nix path is a way to
    # lose a login shell entirely on a box where /nix is a volume that can fail
    # to mount. apt/brew zsh stays in /etc/shells and stays the login shell.
    zsh

    # git is here for the same reason as everything else -- it is a package --
    # but note the bootstrap still needs *some* git to clone this repo before
    # nix exists. apt/brew's copy does that; this one wins on PATH afterwards.
    git
    git-lfs
    tmux

    # --- Fonts ------------------------------------------------------------
    # Replaced the Nerd Font tarball download on Linux and the cask on macOS.
    # fonts.fontconfig.enable (linux.nix) is what makes fc-list see it.
    nerd-fonts.jetbrains-mono
  ];

  # ---------------------------------------------------------------------------
  # Deliberately NOT here
  # ---------------------------------------------------------------------------
  # Not in nixpkgs at all (verified), so their current installers stay:
  #   multi-gitter  -- `go install` in install_packages.sh, or a ~12-line
  #                    buildGoModule derivation later
  #   tfenv         -- git clone; it is a version manager, nixpkgs has no such
  #                    package by design
  #
  # In nixpkgs, but owned by a version manager we are keeping (see the
  # migration plan): adding these would shadow the shims and silently give the
  # wrong toolchain.
  #   nodejs, yarn  -- fnm
  #   python3       -- pyenv
  #   terraform     -- tfenv (also unfree/BUSL)
  #   lua, luarocks -- mise (`mise use -g lua@5.1`)
  #   rustc, cargo  -- rustup, which also owns the wasm32 target and trunk/
  #                    wasm-bindgen-cli built against it
  #
  # Deliberately left to the C toolchain that already exists:
  #   gcc, binutils -- installing a nix toolchain into the profile while
  #                    `go install`, `cargo build` and node-gyp still use the
  #                    system headers is the classic route to glibc/header
  #                    mismatches. build-essential / the Xcode CLT keep it.
  #
  # Enabled in lua/lsp/init.lua but never installed by any script, before or
  # after this migration -- pre-existing gaps, not regressions:
  #   vimls, gopls, hls, zls, csharp_ls, clangd
}
