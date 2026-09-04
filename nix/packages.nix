# The package set that replaces the hand-rolled installers.
#
# Every attribute below was checked against the nixos-unstable package index
# before being written down; the handful of tools nixpkgs does not carry are
# listed at the bottom with what still installs them.
#
# Replaces, once phase 3 lands:
#   install_scripts/shared/install-packages.sh   (the cargo-binstall list)
#   install_scripts/debian/install_packages.sh   (~90% of it)
#   install_scripts/debian/apt-install.sh        (everything not a build dep)
#   install_scripts/osx/install_brew_packages.sh (everything but the casks)
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Core CLI --------------------------------------------------------
    # apt/brew today; eza, bat, procs, ripgrep and starship are also
    # cargo-binstall'd into ~/.cargo/bin, which sits earlier in PATH. Until
    # phase 3 removes them from install-packages.sh the cargo copies win --
    # expect `which -a bat` to show both.
    bat
    eza
    fd
    fzf
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
    # Biggest single win: this deletes the entire Ubuntu-PPA-vs-Debian-tarball
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
    # Replaces the coursier bootstrap + `cs install`, which install_packages.sh
    # deliberately avoids running as `cs setup` because that rewrites ~/.zshrc.
    coursier
    scala
    sbt
    scalafmt

    # --- Fonts ------------------------------------------------------------
    # Replaces the Nerd Font tarball download on Linux and the cask on macOS.
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
  # Blocked on a config change, so they land in phase 3 rather than now:
  #   go     -- .zshrc pins GOROOT=/usr/local/go on Linux; that export has to
  #             go first, or `go` and GOROOT disagree
  #   zsh    -- fine to install, but do not chsh to it while /nix is a mounted
  #             volume that can fail to appear: that locks you out of a login
  #             shell. apt/brew zsh stays the login shell.
  #   gcc, binutils -- installing a nix toolchain into the profile while
  #             `go install`, `cargo build` and node-gyp still use the system
  #             headers is the classic way to get glibc/header mismatches.
  #
  # Enabled in lua/lsp/init.lua but never installed by any script, before or
  # after this migration -- pre-existing gaps, not regressions:
  #   vimls, gopls, hls, zls, csharp_ls, clangd
}
