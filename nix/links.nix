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
      # The rules themselves, under the name every other agent looks for.
      ".agents/AGENTS.md".source = link "agents/AGENTS.md";
      # Claude Code reads CLAUDE.md only, so this one is a stub that imports
      # the file above. Both links point at the checkout, not at each other.
      ".claude/CLAUDE.md".source = link "claude/CLAUDE.md";
    };

    xdg.configFile = {
      "alacritty/alacritty.toml".source = link "alacritty.toml";
      "nvim/init.lua".source = link "init.lua";
      "nvim/lua".source = link "lua";
      # Has to be `link`, not a store copy: lazy.nvim *writes* this file on
      # every sync/update, and writing through the symlink is what puts the
      # pinned plugin revisions in `git diff` instead of in ~/.config.
      # lazy.nvim has already written a real file there on any existing box;
      # activation refuses to overwrite it, so move it aside (or into the
      # checkout) before the first switch.
      "nvim/lazy-lock.json".source = link "lazy-lock.json";
    };
  };
}
