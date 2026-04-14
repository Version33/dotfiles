{

  flake.modules.neovim.toggles = {
    # Snacks.toggle keymaps and lazygit require runtime Lua — can't be declared
    # statically in vim.keymaps since they call methods on runtime objects.
    config.vim.luaConfigRC.lazyvim-toggles = builtins.readFile ./lua/toggles.lua;
  };
}
