# Gated with mkIf rather than by a conditional import: see the note in home.nix.
{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    home.packages = with pkgs; [
      xclip
      wl-clipboard
      # gpg-agent's pinentry-program in install_scripts/debian/setup.sh points
      # at whatever `command -v pinentry-curses` finds; once this is on PATH
      # that resolves into the nix profile.
      pinentry-curses
    ];

    # Generates ~/.config/fontconfig so fc-list/fc-cache see
    # nerd-fonts.jetbrains-mono from the nix profile. Replaces the
    # JetBrainsMono.tar.xz download in install_scripts/debian/install_packages.sh.
    fonts.fontconfig.enable = true;
  };
}
