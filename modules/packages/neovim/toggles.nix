{

  flake.modules.neovim.toggles =
    { lib, ... }:
    {
      # Snacks.toggle keymaps and lazygit require runtime Lua — can't be declared
      # statically in vim.keymaps since they call methods on runtime objects.
      config.vim.luaConfigRC.lazyvim-toggles = lib.nvim.dag.entryAfter [ "pluginConfigs" ] (
        builtins.readFile ./lua/toggles.lua
      );
    };
}
