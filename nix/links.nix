# Dotfile symlinks, gated on `dotfiles.manageLinks` (see home.nix).
{
  config,
  lib,
  dotfilesDir,
  ...
}:

let
  # Points at the checkout rather than copying into /nix/store, so edits are
  # live and `git diff` still sees them. `source = ./path` would give a
  # read-only store copy needing a `switch` per keystroke -- which is why
  # flake.nix has to plumb DOTFILES_DIR in.
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
in
{
  options.dotfiles.manageLinks = lib.mkEnableOption "home-manager-managed dotfile symlinks";

  config = lib.mkIf config.dotfiles.manageLinks {
    home.file = {
      ".zshrc".source = link ".zshrc";
      ".zshenv".source = link ".zshenv";
      ".tmux.conf".source = link ".tmux.conf";
      ".p10k.zsh".source = link ".p10k.zsh";
      ".claude/CLAUDE.md".source = link "claude/CLAUDE.md";
    };

    xdg.configFile = {
      "starship.toml".source = link "starship.toml";
      "alacritty/alacritty.toml".source = link "alacritty.toml";
      "kitty/kitty.conf".source = link "kitty/kitty.conf";
      "kitty/gruvbox.conf".source = link "kitty/gruvbox.conf";
      "nvim/init.lua".source = link "init.lua";
      "nvim/lua".source = link "lua";
    };
  };
}
