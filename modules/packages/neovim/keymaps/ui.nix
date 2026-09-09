{
  flake.modules.neovim.keymaps-ui = {
    config.vim.keymaps = [
      # ── Which-key meta ────────────────────────────────────────────────
      {
        key = "<leader>?";
        mode = "n";
        lua = true;
        action = "function() require('which-key').show({ global=false }) end";
        silent = true;
        desc = "Buffer Keymaps (which-key)";
      }
      {
        key = "<c-w><space>";
        mode = "n";
        lua = true;
        action = "function() require('which-key').show({ keys='<c-w>', loop=true }) end";
        silent = true;
        desc = "Window Hydra Mode (which-key)";
      }

      # ── Noice ─────────────────────────────────────────────────────────
      {
        key = "<leader>snl";
        mode = "n";
        lua = true;
        action = "function() require('noice').cmd('last') end";
        silent = true;
        desc = "Noice Last Message";
      }
      {
        key = "<leader>snh";
        mode = "n";
        lua = true;
        action = "function() require('noice').cmd('history') end";
        silent = true;
        desc = "Noice History";
      }
      {
        key = "<leader>sna";
        mode = "n";
        lua = true;
        action = "function() require('noice').cmd('all') end";
        silent = true;
        desc = "Noice All";
      }
      {
        key = "<leader>snd";
        mode = "n";
        lua = true;
        action = "function() require('noice').cmd('dismiss') end";
        silent = true;
        desc = "Dismiss All Notifications";
      }
      {
        key = "<S-Enter>";
        mode = "c";
        lua = true;
        action = "function() require('noice').redirect(vim.fn.getcmdline()) end";
        silent = true;
        desc = "Redirect Cmdline";
      }
      {
        key = "<c-f>";
        mode = [
          "i"
          "n"
          "s"
        ];
        lua = true;
        expr = true;
        action = "function() if not require('noice.lsp').scroll(4)  then return '<c-f>' end end";
        silent = true;
        desc = "Scroll Forward";
      }
      {
        key = "<c-b>";
        mode = [
          "i"
          "n"
          "s"
        ];
        lua = true;
        expr = true;
        action = "function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end";
        silent = true;
        desc = "Scroll Backward";
      }

      # ── Notifications ─────────────────────────────────────────────────
      {
        key = "<leader>n";
        mode = "n";
        lua = true;
        action = "function() Snacks.notifier.show_history() end";
        silent = true;
        desc = "Notification History";
      }
      {
        key = "<leader>un";
        mode = "n";
        lua = true;
        action = "function() Snacks.notifier.hide() end";
        silent = true;
        desc = "Dismiss All Notifications";
      }

      # ── UI inspect ────────────────────────────────────────────────────
      {
        key = "<leader>ui";
        mode = "n";
        lua = true;
        action = "function() vim.show_pos() end";
        silent = true;
        desc = "Inspect Pos";
      }
      {
        key = "<leader>uI";
        mode = "n";
        lua = true;
        action = "function() vim.treesitter.inspect_tree(); vim.api.nvim_input('I') end";
        silent = true;
        desc = "Inspect Tree";
      }

      # ── Snacks Explorer ───────────────────────────────────────────────
      {
        key = "<leader>fe";
        mode = "n";
        lua = true;
        action = "function() Snacks.explorer({ cwd = Snacks.git.get_root() or vim.fn.getcwd() }) end";
        silent = true;
        desc = "Explorer Snacks (root dir)";
      }
      {
        key = "<leader>fE";
        mode = "n";
        lua = true;
        action = "function() Snacks.explorer() end";
        silent = true;
        desc = "Explorer Snacks (cwd)";
      }
      {
        key = "<leader>e";
        mode = "n";
        lua = true;
        action = "function() Snacks.explorer({ cwd = Snacks.git.get_root() or vim.fn.getcwd() }) end";
        silent = true;
        desc = "Explorer Snacks (root dir)";
      }
      {
        key = "<leader>E";
        mode = "n";
        lua = true;
        action = "function() Snacks.explorer() end";
        silent = true;
        desc = "Explorer Snacks (cwd)";
      }
    ];
  };
}
