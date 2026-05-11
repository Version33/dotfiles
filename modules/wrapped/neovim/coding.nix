{
  flake.modules.neovim.coding =
    { pkgs, ... }:
    {
      config.vim = {
        # LazyVim: Saghen/blink.cmp
        autocomplete.blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
          setupOpts = {
            keymap.preset = "default";
            completion = {
              documentation.auto_show = true;
              documentation.auto_show_delay_ms = 200;
              menu.auto_show = true;
            };
            fuzzy.prebuilt_binaries.download = false;
          };
        };

        # LazyVim: nvim-mini/mini.pairs — full options from LazyVim source
        # nvim-mini/mini.ai — custom textobjects, setup is in luaConfigRC below
        # nvim-mini/mini.surround — gsa=add, gsd=delete, gsr=replace, gsf=find, gsF=find_left, gsh=highlight
        mini = {
          pairs = {
            enable = true;
            setupOpts = {
              modes = {
                insert = true;
                command = true;
                terminal = false;
              };
              skip_next = ''[=[[%w%%%'%[%"%.%`%$]]=]'';
              skip_ts = [ "string" ];
              skip_unbalanced = true;
              markdown = true;
            };
          };

          ai.enable = true;

          surround.enable = true;
        };

        # mini.ai custom textobjects need Lua — wire them via luaConfigRC
        luaConfigRC.mini-ai-textobjects = builtins.readFile ./lua/mini-ai.lua;

        # LazyVim: folke/ts-comments.nvim
        extraPlugins.ts-comments-nvim = {
          package = pkgs.vimPlugins.ts-comments-nvim;
          setup = ''require("ts-comments").setup({})'';
        };

        # LazyVim: folke/lazydev.nvim
        extraPlugins.lazydev-nvim = {
          package = pkgs.vimPlugins.lazydev-nvim;
          setup = ''require("lazydev").setup({})'';
          # nvf puts plugins on the rtp directly so lazydev finds luv automatically
        };
      };
    };
}
