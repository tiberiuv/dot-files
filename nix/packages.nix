# The package set. What is deliberately absent, and why, is at the bottom.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Core CLI --------------------------------------------------------
    # No fzf: zinit installs it with --key-bindings --completion, which writes
    # ~/.fzf.zsh and wires ^T/^R. nixpkgs' fzf has no shell integration, and
    # programs.fzf would generate shell init, which this config avoids.
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
    # tree-sitter is the CLI nvim-treesitter's `main` branch shells out to when
    # building parsers.
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
    coursier
    scala
    sbt
    scalafmt

    # --- Toolchains and base tools ---------------------------------------
    # GOROOT must stay unset (see .zshrc): this go finds its own, and a stale
    # GOROOT gives "go: cannot find GOROOT directory".
    go

    # On PATH, but never the login shell -- chsh to a /nix path loses you a
    # shell the moment /nix fails to mount. apt/brew zsh stays in /etc/shells.
    zsh

    # apt/brew git still bootstraps the clone; this one wins on PATH after.
    git
    git-lfs
    tmux

    # --- Fonts ------------------------------------------------------------
    # fonts.fontconfig.enable (linux.nix) is what makes fc-list see this.
    nerd-fonts.jetbrains-mono
  ];

  # ---------------------------------------------------------------------------
  # Deliberately NOT here
  # ---------------------------------------------------------------------------
  # Not in nixpkgs, so their own installers stay:
  #   multi-gitter  -- `go install`
  #   tfenv         -- git clone
  #
  # In nixpkgs, but adding them would shadow a version manager's shims and
  # silently hand back the wrong toolchain:
  #   nodejs, yarn  -- fnm
  #   python3       -- pyenv
  #   terraform     -- tfenv (also unfree/BUSL)
  #   lua, luarocks -- mise
  #   rustc, cargo  -- rustup, which also owns the wasm32 target and the
  #                    trunk/wasm-bindgen-cli built against it
  #   gcc, binutils -- `go install`, `cargo build` and node-gyp compile against
  #                    the system headers; a nix toolchain in front of them is
  #                    the classic glibc/header mismatch
  #
  # Enabled in lua/lsp/init.lua but installed by nothing, before or after this
  # migration -- pre-existing gaps, not regressions:
  #   vimls, gopls, hls, zls, csharp_ls, clangd
}
