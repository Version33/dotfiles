{
  flake.modules.neovim.linting = {
    # LazyVim: mfussenegger/nvim-lint
    config.vim.diagnostics.nvim-lint = {
      enable = true;
      lint_after_save = true;
    };
  };
}
