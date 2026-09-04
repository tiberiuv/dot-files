# Shared home-manager configuration. Platform splits live in linux.nix /
# darwin.nix; the package list lives in packages.nix.
{
  username,
  homeDirectory,
  ...
}:

{
  # Imported unconditionally. Selecting imports with `pkgs.stdenv.hostPlatform.isLinux`
  # looks tidier but is an infinite recursion: `pkgs` is itself supplied by the
  # module system (_module.args.pkgs), and `imports` has to be resolved before
  # any option can be evaluated. linux.nix and darwin.nix gate their own
  # contents with mkIf instead.
  imports = [
    ./packages.nix
    ./links.nix
    ./linux.nix
    ./darwin.nix
  ];

  home = {
    inherit username homeDirectory;

    # Selects migration semantics for state home-manager already manages, not
    # "which home-manager is this". Set once, never bumped casually.
    stateVersion = "24.11";
  };

  # Puts `home-manager` itself in the profile, so after the first bootstrap
  # nix/switch.sh is a convenience rather than a requirement.
  programs.home-manager.enable = true;

  # home-manager owns the dotfile symlinks (see nix/links.nix). They are
  # mkOutOfStoreSymlink, so they point back into this checkout and stay
  # live-editable; home-manager only tracks and garbage collects them.
  dotfiles.manageLinks = true;

  # Deliberately NOT enabling programs.zsh / programs.git / programs.tmux.
  # Those generate their own ~/.zshrc, ~/.gitconfig and ~/.tmux.conf, which
  # would fight the symlinks that keep those files live-editable in this repo.
  # The cost is that home-manager's session variables are not sourced for us,
  # so .zshenv sources hm-session-vars.sh by hand.
}
