{
  flake.modules.neovim.lsp = {
    config.vim = {
      lsp = {
        enable = true;
        formatOnSave = false; # handled by conform.nvim
        inlayHints.enable = true; # LazyVim enables inlay hints by default
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        lua.enable = true;
        bash.enable = true;

        typescript.enable = true;
        css.enable = true;
        html.enable = true;

        python.enable = true;
        rust.enable = true;
        go.enable = true;

        markdown.enable = true;
        yaml.enable = true;
      };

      # LazyVim diagnostic display config
      luaConfigRC.lsp-diagnostics = builtins.readFile ./lua/lsp-diagnostics.lua;
    };
  };
}
