# Dotfile symlinks. This replaced install_scripts/shared/create_symlinks.sh;
# gated on `dotfiles.manageLinks` (see home.nix), which is on.
{
  config,
  lib,
  dotfilesDir,
  ...
}:

let
  # mkOutOfStoreSymlink points at the working checkout rather than copying the
  # file into /nix/store. That keeps the current workflow intact: edit
  # ~/.zshrc, the change is live immediately, and `git diff` still sees it.
  # `home.file.<n>.source = ./path` would instead produce a read-only store
  # copy needing a `switch` per keystroke -- hence the DOTFILES_DIR plumbing in
  # flake.nix, since a flake cannot otherwise learn its own checkout path.
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
