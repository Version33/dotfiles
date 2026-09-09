{
  flake.modules.neovim.keymaps-buffers = {
    config.vim.keymaps = [
      # ── Buffers ───────────────────────────────────────────────────────
      # Note: <S-h>/<S-l> are owned by bufferline (cycleNext/cyclePrevious in ui.nix)
      {
        key = "[b";
        mode = "n";
        action = "<cmd>bprevious<cr>";
        silent = true;
        desc = "Prev Buffer";
      }
      {
        key = "]b";
        mode = "n";
        action = "<cmd>bnext<cr>";
        silent = true;
        desc = "Next Buffer";
      }
      {
        key = "<leader>bb";
        mode = "n";
        action = "<cmd>e #<cr>";
        silent = true;
        desc = "Switch to Other Buffer";
      }
      {
        key = "<leader>`";
        mode = "n";
        action = "<cmd>e #<cr>";
        silent = true;
        desc = "Switch to Other Buffer";
      }
      {
        key = "<leader>bd";
        mode = "n";
        lua = true;
        action = "function() Snacks.bufdelete() end";
        silent = true;
        desc = "Delete Buffer";
      }
      {
        key = "<leader>bo";
        mode = "n";
        lua = true;
        action = "function() Snacks.bufdelete.other() end";
        silent = true;
        desc = "Delete Other Buffers";
      }
      {
        key = "<leader>bD";
        mode = "n";
        action = "<cmd>bd<cr>";
        silent = true;
        desc = "Delete Buffer and Window";
      }

      # ── Bufferline extras ─────────────────────────────────────────────
      {
        key = "<leader>bp";
        mode = "n";
        action = "<cmd>BufferLineTogglePin<cr>";
        silent = true;
        desc = "Toggle Pin";
      }
      {
        key = "<leader>bP";
        mode = "n";
        action = "<cmd>BufferLineGroupClose ungrouped<cr>";
        silent = true;
        desc = "Delete Non-Pinned Buffers";
      }
      {
        key = "<leader>br";
        mode = "n";
        action = "<cmd>BufferLineCloseRight<cr>";
        silent = true;
        desc = "Delete Buffers to the Right";
      }
      {
        key = "<leader>bl";
        mode = "n";
        action = "<cmd>BufferLineCloseLeft<cr>";
        silent = true;
        desc = "Delete Buffers to the Left";
      }
      {
        key = "<leader>bj";
        mode = "n";
        action = "<cmd>BufferLinePick<cr>";
        silent = true;
        desc = "Pick Buffer";
      }
      {
        key = "[B";
        mode = "n";
        action = "<cmd>BufferLineMovePrev<cr>";
        silent = true;
        desc = "Move Buffer Prev";
      }
      {
        key = "]B";
        mode = "n";
        action = "<cmd>BufferLineMoveNext<cr>";
        silent = true;
        desc = "Move Buffer Next";
      }
    ];
  };
}
