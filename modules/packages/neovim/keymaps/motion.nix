{
  flake.modules.neovim.keymaps-motion = {
    config.vim.keymaps = [
      # ── Better up/down (respect wrapped lines) ────────────────────────
      {
        key = "j";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gj' : 'j'";
        expr = true;
        silent = true;
        desc = "Down";
      }
      {
        key = "k";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gk' : 'k'";
        expr = true;
        silent = true;
        desc = "Up";
      }
      {
        key = "<Down>";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gj' : 'j'";
        expr = true;
        silent = true;
        desc = "Down";
      }
      {
        key = "<Up>";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gk' : 'k'";
        expr = true;
        silent = true;
        desc = "Up";
      }

      # ── Saner n/N — always forward/backward, open folds ──────────────
      {
        key = "n";
        mode = "n";
        action = "'Nn'[v:searchforward].'zv'";
        expr = true;
        silent = true;
        desc = "Next Search Result";
      }
      {
        key = "n";
        mode = [
          "x"
          "o"
        ];
        action = "'Nn'[v:searchforward]";
        expr = true;
        silent = true;
        desc = "Next Search Result";
      }
      {
        key = "N";
        mode = "n";
        action = "'nN'[v:searchforward].'zv'";
        expr = true;
        silent = true;
        desc = "Prev Search Result";
      }
      {
        key = "N";
        mode = [
          "x"
          "o"
        ];
        action = "'nN'[v:searchforward]";
        expr = true;
        silent = true;
        desc = "Prev Search Result";
      }

      # ── Flash treesitter incremental selection ─────────────────────────
      {
        key = "<c-space>";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() require('flash').treesitter() end";
        silent = true;
        desc = "Flash Treesitter Selection";
      }
    ];
  };
}
