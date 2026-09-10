{
  flake.modules.neovim.git =
    { lib, ... }:
    {
      config.vim = {
        git = {
          # Only gitsigns is wanted (hunk signs + blame/diff keymaps below). git.enable is
          # an umbrella that also turns on vim-fugitive, git-conflict, gitlinker-nvim and
          # hunk-nvim (git-conflict's ]x/[x are even reversed vs this config's ]/[ convention).
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

        # gitsigns has no `textobject` setupOpts field (unknown keys warn on startup);
        # the hunk textobject below is a plain operator-pending mapping instead.
        keymaps = [
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
        luaConfigRC.lazyvim-git = lib.nvim.dag.entryAfter [ "pluginConfigs" ] (
          builtins.readFile ./lua/git.lua
        );
      };
    };
}
