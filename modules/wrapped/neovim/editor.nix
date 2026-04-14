{
  flake.modules.neovim.editor = {
    config.vim = {
      # LazyVim: folke/which-key.nvim
      # Only set basic options here — spec is in luaConfigRC below because
      # which-key v3 expects positional mixed-tables ({ lhs, group=, icon= })
      # which toLuaObject cannot represent (it only produces pure dicts).
      binds.whichKey = {
        enable = true;
        setupOpts = {
          preset = "helix";
          notify = false;
        };
      };

      # LazyVim: folke/todo-comments.nvim
      notes.todo-comments.enable = true;

      # LazyVim: folke/flash.nvim
      utility.motion.flash-nvim.enable = true;

      # LazyVim: MagicDuck/grug-far.nvim
      utility.grug-far-nvim = {
        enable = true;
        setupOpts.headerMaxWidth = 80;
      };

      # which-key group spec with icons — must be Lua because the format
      # { "<leader>s", group = "search", icon = "…" } is a mixed array/dict
      # that Nix attrsets cannot produce via toLuaObject.
      luaConfigRC.whichkey-groups = builtins.readFile ./lua/whichkey-groups.lua;
    };
  };
}
