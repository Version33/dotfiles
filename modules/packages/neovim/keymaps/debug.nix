{
  flake.modules.neovim.keymaps-debug = {
    config.vim.keymaps = [
      # ── nvim-dap (LazyVim) ────────────────────────────────────────────
      {
        key = "<leader>dB";
        mode = "n";
        lua = true;
        action = "function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end";
        silent = true;
        desc = "Breakpoint Condition";
      }
      {
        key = "<leader>db";
        mode = "n";
        lua = true;
        action = "function() require('dap').toggle_breakpoint() end";
        silent = true;
        desc = "Toggle Breakpoint";
      }
      {
        key = "<leader>dc";
        mode = "n";
        lua = true;
        action = "function() require('dap').continue() end";
        silent = true;
        desc = "Run/Continue";
      }
      {
        key = "<leader>dC";
        mode = "n";
        lua = true;
        action = "function() require('dap').run_to_cursor() end";
        silent = true;
        desc = "Run to Cursor";
      }
      {
        key = "<leader>dg";
        mode = "n";
        lua = true;
        action = "function() require('dap').goto_() end";
        silent = true;
        desc = "Go to Line (No Execute)";
      }
      {
        key = "<leader>di";
        mode = "n";
        lua = true;
        action = "function() require('dap').step_into() end";
        silent = true;
        desc = "Step Into";
      }
      {
        key = "<leader>dj";
        mode = "n";
        lua = true;
        action = "function() require('dap').down() end";
        silent = true;
        desc = "Down";
      }
      {
        key = "<leader>dk";
        mode = "n";
        lua = true;
        action = "function() require('dap').up() end";
        silent = true;
        desc = "Up";
      }
      {
        key = "<leader>dl";
        mode = "n";
        lua = true;
        action = "function() require('dap').run_last() end";
        silent = true;
        desc = "Run Last";
      }
      {
        key = "<leader>do";
        mode = "n";
        lua = true;
        action = "function() require('dap').step_out() end";
        silent = true;
        desc = "Step Out";
      }
      {
        key = "<leader>dO";
        mode = "n";
        lua = true;
        action = "function() require('dap').step_over() end";
        silent = true;
        desc = "Step Over";
      }
      {
        key = "<leader>dP";
        mode = "n";
        lua = true;
        action = "function() require('dap').pause() end";
        silent = true;
        desc = "Pause";
      }
      {
        key = "<leader>dr";
        mode = "n";
        lua = true;
        action = "function() require('dap').repl.toggle() end";
        silent = true;
        desc = "Toggle REPL";
      }
      {
        key = "<leader>ds";
        mode = "n";
        lua = true;
        action = "function() require('dap').session() end";
        silent = true;
        desc = "Session";
      }
      {
        key = "<leader>dt";
        mode = "n";
        lua = true;
        action = "function() require('dap').terminate() end";
        silent = true;
        desc = "Terminate";
      }
      {
        key = "<leader>dw";
        mode = "n";
        lua = true;
        action = "function() require('dap.ui.widgets').hover() end";
        silent = true;
        desc = "Widgets";
      }

      # ── nvim-dap-ui (LazyVim) ─────────────────────────────────────────
      {
        key = "<leader>du";
        mode = "n";
        lua = true;
        action = "function() require('dapui').toggle({}) end";
        silent = true;
        desc = "Dap UI";
      }
      {
        key = "<leader>de";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() require('dapui').eval() end";
        silent = true;
        desc = "Eval";
      }
    ];
  };
}
