# Shared home-manager configuration. Platform splits live in linux.nix /
# darwin.nix; the package list lives in packages.nix.
{
  username,
  homeDirectory,
  ...
}:

{
  # Never select these with `pkgs.stdenv.hostPlatform.isLinux`: that is an
  # infinite recursion, since `pkgs` comes from the module system and `imports`
  # must resolve before any option evaluates. linux.nix/darwin.nix use mkIf.
  imports = [
    ./packages.nix
    ./links.nix
    ./linux.nix
    ./darwin.nix
  ];

  home = {
    inherit username homeDirectory;

    # Migration semantics for state home-manager manages, not "which version is
    # this". Set once, never bumped casually.
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  dotfiles.manageLinks = true;

  # programs.zsh / programs.git / programs.tmux stay off on purpose: they
  # generate their own ~/.zshrc, ~/.gitconfig and ~/.tmux.conf, which would
  # fight the symlinks that keep those files live-editable here. The cost is
  # that .zshenv has to source hm-session-vars.sh by hand.
}
