{

  flake.modules.neovim.treesitter =
    { pkgs, ... }:
    let
      grammars = pkgs.vimPlugins.nvim-treesitter.grammarPlugins;
    in
    {
      config.vim.treesitter = {
        enable = true;
        fold = true;
        autotagHtml = true; # LazyVim: windwp/nvim-ts-autotag

        # Matches LazyVim's ensure_installed (plus extras nvf provides by default)
        grammars = with grammars; [
          bash
          css
          diff
          html
          javascript
          jsdoc
          json
          luadoc
          luap
          markdown
          markdown_inline
          nix
          printf
          python
          regex
          rust
          toml
          tsx
          typescript
          xml
          yaml
        ];

        # LazyVim: nvim-treesitter/nvim-treesitter-textobjects
        textobjects = {
          enable = true;
          setupOpts.move = {
            enable = true;
            set_jumps = true;
          };
        };
      };
    };

}
