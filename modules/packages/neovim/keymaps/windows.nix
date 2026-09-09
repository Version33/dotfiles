{
  flake.modules.neovim.keymaps-windows = {
    config.vim.keymaps = [
      # ── Window navigation ─────────────────────────────────────────────
      {
        key = "<C-h>";
        mode = "n";
        action = "<C-w>h";
        silent = true;
        desc = "Go to Left Window";
      }
      {
        key = "<C-j>";
        mode = "n";
        action = "<C-w>j";
        silent = true;
        desc = "Go to Lower Window";
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<C-w>k";
        silent = true;
        desc = "Go to Upper Window";
      }
      {
        key = "<C-l>";
        mode = "n";
        action = "<C-w>l";
        silent = true;
        desc = "Go to Right Window";
      }

      # ── Window resize ─────────────────────────────────────────────────
      {
        key = "<C-Up>";
        mode = "n";
        action = "<cmd>resize +2<cr>";
        silent = true;
        desc = "Increase Window Height";
      }
      {
        key = "<C-Down>";
        mode = "n";
        action = "<cmd>resize -2<cr>";
        silent = true;
        desc = "Decrease Window Height";
      }
      {
        key = "<C-Left>";
        mode = "n";
        action = "<cmd>vertical resize -2<cr>";
        silent = true;
        desc = "Decrease Window Width";
      }
      {
        key = "<C-Right>";
        mode = "n";
        action = "<cmd>vertical resize +2<cr>";
        silent = true;
        desc = "Increase Window Width";
      }

      # ── Window splits ─────────────────────────────────────────────────
      {
        key = "<leader>-";
        mode = "n";
        action = "<C-w>s";
        silent = true;
        desc = "Split Window Below";
      }
      {
        key = "<leader>|";
        mode = "n";
        action = "<C-w>v";
        silent = true;
        desc = "Split Window Right";
      }
      {
        key = "<leader>wd";
        mode = "n";
        action = "<C-w>c";
        silent = true;
        desc = "Delete Window";
      }

      # ── Tabs ──────────────────────────────────────────────────────────
      {
        key = "<leader><tab><tab>";
        mode = "n";
        action = "<cmd>tabnew<cr>";
        silent = true;
        desc = "New Tab";
      }
      {
        key = "<leader><tab>d";
        mode = "n";
        action = "<cmd>tabclose<cr>";
        silent = true;
        desc = "Close Tab";
      }
      {
        key = "<leader><tab>]";
        mode = "n";
        action = "<cmd>tabnext<cr>";
        silent = true;
        desc = "Next Tab";
      }
      {
        key = "<leader><tab>[";
        mode = "n";
        action = "<cmd>tabprevious<cr>";
        silent = true;
        desc = "Previous Tab";
      }
      {
        key = "<leader><tab>f";
        mode = "n";
        action = "<cmd>tabfirst<cr>";
        silent = true;
        desc = "First Tab";
      }
      {
        key = "<leader><tab>l";
        mode = "n";
        action = "<cmd>tablast<cr>";
        silent = true;
        desc = "Last Tab";
      }
      {
        key = "<leader><tab>o";
        mode = "n";
        action = "<cmd>tabonly<cr>";
        silent = true;
        desc = "Close Other Tabs";
      }
    ];
  };
}
