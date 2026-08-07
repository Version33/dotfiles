{
  flake.modules.neovim.git =
    { lib, ... }:
    {
      config.vim.git = {
        # Only gitsigns is wanted here (hunk signs/staging + the blame/diff
        # keymaps below). nvf's `git.enable` is an umbrella whose sub-plugin
        # options each default their own `enable` to it (see
        # modules/plugins/git/*/*.nix in nvf), so leaving it `true` would
        # silently turn on vim-fugitive, git-conflict, gitlinker-nvim and
        # hunk-nvim too — none of which this config uses, and git-conflict's
        # `]x`/`[x` defaults are even direction-swapped vs. the `]`/`[`
        # convention the rest of this config follows. Keep the umbrella off
        # and opt gitsigns in explicitly instead of flipping this back on.
        enable = false;

        gitsigns = {
          enable = true;
          # LazyVim sign glyphs
          setupOpts = {
            signs = {
              add.text = "▎";
              change.text = "▎";
              delete.text = "";
              topdelete.text = "";
              changedelete.text = "▎";
              untracked.text = "▎";
            };
            signs_staged = {
              add.text = "▎";
              change.text = "▎";
              delete.text = "";
              topdelete.text = "";
              changedelete.text = "▎";
            };
          };
          mappings = {
            nextHunk = "]h";
            previousHunk = "[h";
            stageHunk = "<leader>ghs";
            resetHunk = "<leader>ghr";
            stageBuffer = "<leader>ghS";
            undoStageHunk = "<leader>ghu";
            resetBuffer = "<leader>ghR";
            previewHunk = "<leader>ghp";
            blameLine = "<leader>ghb";
            toggleBlame = "<leader>ghB";
            diffThis = "<leader>ghd";
            diffProject = "<leader>ghD";
            toggleDeleted = "<leader>ghT";
          };
        };
      };

      # gitsigns has no `textobject` setupOpts field (it warns on every
      # startup); the real hunk textobject is a plain operator-pending mapping.
      config.vim.keymaps = [
        {
          key = "ih";
          mode = [
            "o"
            "x"
          ];
          action = ":<C-U>Gitsigns select_hunk<CR>";
          desc = "GitSigns Select Hunk";
        }
      ];

      # Git keymaps that need runtime Lua (Snacks picker, lazygit, gitsigns first/last hunk)
      config.vim.luaConfigRC.lazyvim-git = lib.nvim.dag.entryAfter [ "pluginConfigs" ] (
        builtins.readFile ./lua/git.lua
      );
    };
}
