# Gated with mkIf rather than by a conditional import: see the note in home.nix.
{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    home.packages = with pkgs; [
      xclip
      wl-clipboard
      # On PATH for anything that shells out to it by name; gpg-agent gets the
      # store path below instead.
      pinentry-curses
    ];

    dotfiles.gpg.pinentry = "${pkgs.pinentry-curses}/bin/pinentry-curses";

    # Generates ~/.config/fontconfig so fc-list/fc-cache see
    # nerd-fonts.jetbrains-mono from the nix profile. Replaces the
    # JetBrainsMono.tar.xz download in install_scripts/debian/install_packages.sh.
    fonts.fontconfig.enable = true;
  };
}
