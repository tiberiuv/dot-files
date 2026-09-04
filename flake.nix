{
  description = "dot-files: declarative packages + home-manager for macOS and Debian/Ubuntu";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      # ----------------------------------------------------------------------
      # Location independence
      # ----------------------------------------------------------------------
      # This checkout has to work wherever it happens to live: ~/dot-files on a
      # laptop, ~/.config/coderv2/dotfiles in a Coder workspace, /tmp/whatever
      # in a throwaway container. A flake cannot see its own working directory
      # -- `./.` evaluates to the read-only /nix/store *copy* of the repo, which
      # is precisely the thing nix/links.nix must not point symlinks at -- so
      # the real path is read from the environment at switch time instead.
      #
      # That is what makes `--impure` mandatory here. It buys exactly three
      # strings; every package still resolves against the nixpkgs revision
      # pinned in flake.lock, so reproducibility of the package set is
      # unaffected. nix/switch.sh sets all three.
      env =
        name: default:
        let
          v = builtins.getEnv name;
        in
        if v == "" then default else v;

      homeDirectory = env "HOME" (throw "HOME is unset -- run nix/switch.sh rather than nix directly");
      username = env "USER" (baseNameOf homeDirectory);

      # switch.sh resolves this from its own location (following symlinks), so
      # it is correct no matter how the script was invoked. The PWD fallback
      # covers a hand-run `nix build` from inside the checkout; the throw
      # covers everything else, loudly, instead of silently linking to /nix/store.
      dotfilesDir = env "DOTFILES_DIR" (
        env "PWD" (throw "DOTFILES_DIR is unset -- run nix/switch.sh rather than nix directly")
      );

      # Overridable so a cross-check (`NIX_SYSTEM=aarch64-darwin nix/switch.sh --dry-run`)
      # can evaluate another platform's config without being on that platform.
      system = env "NIX_SYSTEM" builtins.currentSystem;

      pkgs = import nixpkgs {
        inherit system;
        # terraform (BUSL) and the temurin JDKs are unfree. Neither is in
        # nix/packages.nix today -- tfenv still owns terraform -- but leaving
        # this off turns a future one-line addition into a confusing eval error.
        config.allowUnfree = true;
      };

      homeConfig = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit dotfilesDir username homeDirectory; };
        modules = [ ./nix/home.nix ];
      };
    in
    {
      # `default` is what switch.sh targets. The $USER alias exists so a bare
      # `home-manager switch --flake <path> --impure` also resolves, since
      # home-manager looks up `<user>@<host>` then `<user>`.
      homeConfigurations = {
        default = homeConfig;
      } // {
        ${username} = homeConfig;
      };
    };
}
