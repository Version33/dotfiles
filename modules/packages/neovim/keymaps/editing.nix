{
  flake.modules.neovim.keymaps-editing = {
    config.vim.keymaps = [
      # ── Move lines ────────────────────────────────────────────────────
      {
        key = "<A-j>";
        mode = "n";
        action = "<cmd>execute 'move .+' . v:count1<cr>==";
        silent = true;
        desc = "Move Down";
      }
      {
        key = "<A-k>";
        mode = "n";
        action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
        silent = true;
        desc = "Move Up";
      }
      {
        key = "<A-j>";
        mode = "i";
        action = "<esc><cmd>m .+1<cr>==gi";
        silent = true;
        desc = "Move Down";
      }
      {
        key = "<A-k>";
        mode = "i";
        action = "<esc><cmd>m .-2<cr>==gi";
        silent = true;
        desc = "Move Up";
      }
      {
        key = "<A-j>";
        mode = "v";
        action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
        silent = true;
        desc = "Move Down";
      }
      {
        key = "<A-k>";
        mode = "v";
        action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
        silent = true;
        desc = "Move Up";
      }

      # ── Undo break-points in insert mode ──────────────────────────────
      {
        key = ",";
        mode = "i";
        action = ",<c-g>u";
      }
      {
        key = ".";
        mode = "i";
        action = ".<c-g>u";
      }
      {
        key = ";";
        mode = "i";
        action = ";<c-g>u";
      }

      # ── Better indenting (stay in visual) ─────────────────────────────
      {
        key = "<";
        mode = "x";
        action = "<gv";
        desc = "Indent Left";
      }
      {
        key = ">";
        mode = "x";
        action = ">gv";
        desc = "Indent Right";
      }

      # ── Comment above / below ─────────────────────────────────────────
      {
        key = "gco";
        mode = "n";
        action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
        desc = "Add Comment Below";
      }
      {
        key = "gcO";
        mode = "n";
        action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
        desc = "Add Comment Above";
      }
    ];
  };
}
