# Gated with mkIf rather than by a conditional import: see the note in home.nix.
{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    home.packages = with pkgs; [
      pinentry_mac
      # Keeps Touch ID working for sudo inside tmux; pairs with the sudo_local
      # edit in install_scripts/osx/setup.sh.
      pam-reattach
    ];
  };

  # Not moved off Homebrew, on purpose:
  #   - casks (firefox@developer-edition, temurin11, docker): nix cannot
  #     install macOS .app bundles properly.
  #   - alacritty, kitty: nixpkgs builds them for darwin, but Dock/Spotlight
  #     integration is poor compared to the cask.
  #   - font-jetbrains-mono-nerd-font: superseded by nerd-fonts.jetbrains-mono
  #     in packages.nix once phase 3 trims install_brew_packages.sh.
}
