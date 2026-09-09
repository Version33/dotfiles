{
  # LazyVim: folke/persistence.nvim — session management
  flake.modules.neovim.session =
    { pkgs, ... }:
    {
      config.vim.extraPlugins.persistence-nvim = {
        package = pkgs.vimPlugins.persistence-nvim;
        setup = builtins.readFile ./lua/persistence.lua;
      };
    };
}
