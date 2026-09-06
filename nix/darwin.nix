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

    # The helper ships with Apple's git; there is no such thing on Linux, so it
    # cannot live in the shared git.nix.
    programs.git.settings.credential.helper = "osxkeychain";

    dotfiles.gpg.pinentry = "${pkgs.pinentry_mac}/bin/pinentry-mac";
  };

  # Not moved off Homebrew, on purpose:
  #   - casks (firefox@developer-edition, temurin11, docker): nix cannot
  #     install macOS .app bundles properly.
  #   - alacritty: nixpkgs builds it for darwin, but Dock/Spotlight
  #     integration is poor compared to the cask.
  #   - font-jetbrains-mono-nerd-font: superseded by nerd-fonts.jetbrains-mono
  #     in packages.nix once phase 3 trims install_brew_packages.sh.
}
