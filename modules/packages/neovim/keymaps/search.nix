{
  flake.modules.neovim.keymaps-search = {
    config.vim.keymaps = [
      # ── fzf-lua ───────────────────────────────────────────────────────
      {
        key = "<leader><space>";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').files() end";
        silent = true;
        desc = "Find Files";
      }
      {
        key = "<leader>ff";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').files() end";
        silent = true;
        desc = "Find Files";
      }
      {
        key = "<leader>fF";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').files({ cwd = vim.fn.getcwd() }) end";
        silent = true;
        desc = "Find Files (cwd)";
      }
      {
        key = "<leader>fc";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').files({ cwd = vim.fs.normalize('~/nixos/modules/wrapped/neovim') }) end";
        silent = true;
        desc = "Find Config File";
      }
      {
        key = "<leader>fp";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.projects() end";
        silent = true;
        desc = "Projects";
      }
      {
        key = "<leader>fg";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').git_files() end";
        silent = true;
        desc = "Find Git Files";
      }
      {
        key = "<leader>fr";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').oldfiles() end";
        silent = true;
        desc = "Recent Files";
      }
      {
        key = "<leader>fR";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').oldfiles({ cwd = vim.fn.getcwd() }) end";
        silent = true;
        desc = "Recent (cwd)";
      }
      {
        key = "<leader>fb";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').buffers() end";
        silent = true;
        desc = "Buffers";
      }
      {
        key = "<leader>sg";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').live_grep() end";
        silent = true;
        desc = "Grep";
      }
      {
        key = "<leader>sw";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() require('fzf-lua').grep_cword() end";
        silent = true;
        desc = "Grep Word";
      }
      {
        key = "<leader>ss";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').lsp_document_symbols() end";
        silent = true;
        desc = "LSP Symbols";
      }
      {
        key = "<leader>sS";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').lsp_workspace_symbols() end";
        silent = true;
        desc = "LSP Workspace Symbols";
      }
      {
        key = "<leader>sd";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').diagnostics_document() end";
        silent = true;
        desc = "Document Diagnostics";
      }
      {
        key = "<leader>sD";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').diagnostics_workspace() end";
        silent = true;
        desc = "Workspace Diagnostics";
      }
      {
        key = "<leader>sh";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').help_tags() end";
        silent = true;
        desc = "Help Pages";
      }
      {
        key = "<leader>sk";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').keymaps() end";
        silent = true;
        desc = "Keymaps";
      }
      {
        key = "<leader>sc";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').command_history() end";
        silent = true;
        desc = "Command History";
      }
      {
        key = "<leader>/";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').lgrep_curbuf() end";
        silent = true;
        desc = "Buffer Lines";
      }

      # ── fzf-lua extended search ───────────────────────────────────────
      {
        key = "<leader>sB";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').lines() end";
        silent = true;
        desc = "Grep Open Buffers";
      }
      {
        key = "<leader>s\"";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').registers() end";
        silent = true;
        desc = "Registers";
      }
      {
        key = "<leader>sR";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').resume() end";
        silent = true;
        desc = "Resume";
      }
      {
        key = "<leader>sj";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').jumps() end";
        silent = true;
        desc = "Jumps";
      }
      {
        key = "<leader>sm";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').marks() end";
        silent = true;
        desc = "Marks";
      }
      {
        key = "<leader>sC";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').commands() end";
        silent = true;
        desc = "Commands";
      }
      {
        key = "<leader>sH";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').highlights() end";
        silent = true;
        desc = "Highlights";
      }
      {
        key = "<leader>sM";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').man_pages() end";
        silent = true;
        desc = "Man Pages";
      }
      {
        key = "<leader>sq";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').quickfix() end";
        silent = true;
        desc = "Quickfix List";
      }
      {
        key = "<leader>su";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.undo() end";
        silent = true;
        desc = "Undo History";
      }
      {
        key = "<leader>s/";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').search_history() end";
        silent = true;
        desc = "Search History";
      }
      {
        key = "<leader>sp";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').builtin() end";
        silent = true;
        desc = "Fzf-Lua Builtins";
      }
      {
        key = "<leader>gc";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').git_commits() end";
        silent = true;
        desc = "Git Commits";
      }
      {
        key = "<leader>gs";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').git_status() end";
        silent = true;
        desc = "Git Status";
      }

      # ── Grug-far ──────────────────────────────────────────────────────
      {
        key = "<leader>sr";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() require('grug-far').open({ prefills={ search=vim.fn.expand('<cword>') } }) end";
        silent = true;
        desc = "Search and Replace";
      }
    ];
  };
}
