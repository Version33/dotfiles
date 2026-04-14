{
  flake.modules.neovim.keymaps-files = {
    config.vim.keymaps = [
      # ── Escape / clear search ─────────────────────────────────────────
      {
        key = "<esc>";
        mode = [
          "i"
          "n"
          "s"
        ];
        action = "<cmd>nohlsearch<cr><esc>";
        silent = true;
        desc = "Escape and Clear hlsearch";
      }
      {
        key = "<leader>ur";
        mode = "n";
        action = "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>";
        silent = true;
        desc = "Redraw / Clear hlsearch / Diff Update";
      }

      # ── Save / quit ───────────────────────────────────────────────────
      {
        key = "<C-s>";
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        action = "<cmd>w<cr><esc>";
        silent = true;
        desc = "Save File";
      }
      {
        key = "<leader>qq";
        mode = "n";
        action = "<cmd>qa<cr>";
        silent = true;
        desc = "Quit All";
      }
      {
        key = "<leader>K";
        mode = "n";
        action = "<cmd>norm! K<cr>";
        silent = true;
        desc = "Keywordprg";
      }

      # ── Files ─────────────────────────────────────────────────────────
      {
        key = "<leader>fn";
        mode = "n";
        action = "<cmd>enew<cr>";
        silent = true;
        desc = "New File";
      }
    ];
  };
}
