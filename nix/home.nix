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

  # ---------------------------------------------------------------------------
  # Phase 1: packages only.
  # ---------------------------------------------------------------------------
  # ~/.zshrc and friends are still symlinked by
  # install_scripts/shared/create_symlinks.sh. Flipping this to true (phase 2)
  # hands those symlinks to home-manager -- which then tracks and garbage
  # collects them -- and makes that script deletable. Do it only after removing
  # the existing symlinks by hand: home-manager refuses to clobber files it did
  # not create, by design.
  dotfiles.manageLinks = false;

  # Deliberately NOT enabling programs.zsh / programs.git / programs.tmux.
  # Those generate their own ~/.zshrc, ~/.gitconfig and ~/.tmux.conf, which
  # would fight the symlinks that keep those files live-editable in this repo.
  # The cost is that home-manager's session variables are not sourced for us;
  # phase 2 adds this line near the top of .zshrc:
  #
  #   [ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ] \
  #     && . ~/.nix-profile/etc/profile.d/hm-session-vars.sh
}
