{
  flake.modules.neovim.formatting =
    { lib, pkgs, ... }:
    {
      config.vim.formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          # LazyVim uses default_format_opts + format_on_save via its own system.
          # We declare format_on_save directly since we don't have LazyVim's format layer.
          default_format_opts = {
            timeout_ms = 3000;
            async = false;
            quiet = false;
            lsp_format = "fallback";
          };
          format_on_save = lib.generators.mkLuaInline ''function(bufnr) if not vim.g.autoformat or vim.b[bufnr].autoformat == false then return end return { timeout_ms = 3000, lsp_format = "fallback" } end'';
          # LazyVim's base set — language extras add more
          formatters_by_ft = {
            lua = [ "stylua" ];
            sh = [ "shfmt" ];
            nix = [ "nixfmt" ];
            python = [ "ruff_format" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            css = [ "prettier" ];
            html = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            markdown = [ "prettier" ];
            go = [ "gofmt" ];
            rust = [ "rustfmt" ];
          };
          formatters.injected = {
            options.ignore_errors = true;
          };
        };
      };

      # ruff/gofmt/nixfmt binaries so conform's declared formatters actually
      # resolve — nvf's extraPackages puts them on the wrapped nvim's PATH.
      config.vim.extraPackages = [
        pkgs.ruff
        pkgs.go
        pkgs.nixfmt
      ];
    };
}
