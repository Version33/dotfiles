{
  flake.modules.neovim.autocmds = {
    config.vim.luaConfigRC.lazyvim-autocmds = builtins.readFile ./lua/autocmds.lua;
  };
}
