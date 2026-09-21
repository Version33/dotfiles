{
  flake.modules.neovim.debugger = {
    config.vim = {
      # LazyVim: mfussenegger/nvim-dap + rcarriga/nvim-dap-ui
      debugger.nvim-dap = {
        enable = true;
        ui = {
          enable = true;
          autoStart = true; # dapui open/close on session start/end, like LazyVim
        };
        # keymaps/debug.nix defines the LazyVim scheme; null nvf's so they don't duplicate.
        mappings = {
          continue = null;
          restart = null;
          terminate = null;
          runLast = null;
          toggleRepl = null;
          hover = null;
          toggleBreakpoint = null;
          runToCursor = null;
          stepInto = null;
          stepOut = null;
          stepOver = null;
          stepBack = null;
          goUp = null;
          goDown = null;
          toggleDapUI = null;
        };
      };

      # Per-language adapters: rust -> codelldb, python -> debugpy, go -> delve.
      languages.enableDAP = true;
    };
  };
}
