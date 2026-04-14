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
        mini.pairs = {
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

        # LazyVim: nvim-mini/mini.ai — full custom textobjects from LazyVim source
        # Note: setup is handled entirely in luaConfigRC.mini-ai-textobjects below
        # (custom textobjects require Lua function calls that Nix can't express)
        mini.ai.enable = true;

        # LazyVim: nvim-mini/mini.surround
        # Mappings: gsa=add, gsd=delete, gsr=replace, gsf=find, gsF=find_left, gsh=highlight
        mini.surround.enable = true;

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
          # Note: the ${3rd}/luv/library path from LazyVim is lazy.nvim-specific;
          # nvf puts plugins on the rtp directly so lazydev finds luv automatically.
        };
      };
    };
}
