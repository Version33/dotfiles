{ self, ... }:
{
  flake.modules.neovim.keymaps-tools =
    { pkgs, ... }:
    let
      omp = "${self.packages.${pkgs.stdenv.hostPlatform.system}.oh-my-pi}/bin/omp";
    in
    {
      config.vim.keymaps = [
        # ── Trouble ───────────────────────────────────────────────────────
        {
          key = "<leader>xx";
          mode = "n";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          silent = true;
          desc = "Diagnostics (Trouble)";
        }
        {
          key = "<leader>xX";
          mode = "n";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          silent = true;
          desc = "Buffer Diagnostics (Trouble)";
        }
        {
          key = "<leader>cs";
          mode = "n";
          action = "<cmd>Trouble symbols toggle<cr>";
          silent = true;
          desc = "Symbols (Trouble)";
        }
        {
          key = "<leader>cS";
          mode = "n";
          action = "<cmd>Trouble lsp toggle<cr>";
          silent = true;
          desc = "LSP (Trouble)";
        }
        {
          key = "<leader>xL";
          mode = "n";
          action = "<cmd>Trouble loclist toggle<cr>";
          silent = true;
          desc = "Location List (Trouble)";
        }
        {
          key = "<leader>xQ";
          mode = "n";
          action = "<cmd>Trouble qflist toggle<cr>";
          silent = true;
          desc = "Quickfix List (Trouble)";
        }

        # ── Todo-comments ─────────────────────────────────────────────────
        {
          key = "]t";
          mode = "n";
          lua = true;
          action = "function() require('todo-comments').jump_next() end";
          silent = true;
          desc = "Next Todo Comment";
        }
        {
          key = "[t";
          mode = "n";
          lua = true;
          action = "function() require('todo-comments').jump_prev() end";
          silent = true;
          desc = "Previous Todo Comment";
        }
        {
          key = "<leader>xt";
          mode = "n";
          action = "<cmd>Trouble todo toggle<cr>";
          silent = true;
          desc = "Todo (Trouble)";
        }
        {
          key = "<leader>xT";
          mode = "n";
          action = "<cmd>Trouble todo toggle filter={tag={TODO,FIX,FIXME}}<cr>";
          silent = true;
          desc = "Todo/Fix/Fixme (Trouble)";
        }
        {
          key = "<leader>st";
          mode = "n";
          lua = true;
          action = "function() require('fzf-lua').grep({ search='TODO|FIXME|HACK|NOTE', no_esc=true }) end";
          silent = true;
          desc = "Todo";
        }

        # ── Session (persistence.nvim) ────────────────────────────────────
        {
          key = "<leader>qs";
          mode = "n";
          lua = true;
          action = "function() require('persistence').load() end";
          silent = true;
          desc = "Restore Session";
        }
        {
          key = "<leader>qS";
          mode = "n";
          lua = true;
          action = "function() require('persistence').select() end";
          silent = true;
          desc = "Select Session";
        }
        {
          key = "<leader>ql";
          mode = "n";
          lua = true;
          action = "function() require('persistence').load({ last=true }) end";
          silent = true;
          desc = "Restore Last Session";
        }
        {
          key = "<leader>qd";
          mode = "n";
          lua = true;
          action = "function() require('persistence').stop() end";
          silent = true;
          desc = "Don't Save Current Session";
        }

        # ── oh-my-pi ──────────────────────────────────────────────────────
        # Ctrl+. needs a terminal that speaks the kitty keyboard protocol
        # (kitty does); otherwise the key never reaches Neovim.
        {
          key = "<C-.>";
          mode = [
            "n"
            "t"
          ];
          lua = true;
          action = ''
            function()
              require("snacks").terminal.toggle("${omp}", {
                win = { position = "right", width = 0.4 },
              })
            end
          '';
          silent = true;
          desc = "oh-my-pi (right split)";
        }

        # ── tuxedo ────────────────────────────────────────────────────────
        {
          key = "<leader>T";
          mode = "n";
          action = "<cmd>Tuxedo<cr>";
          silent = true;
          desc = "Tuxedo (todo.txt)";
        }
      ];
    };
}
