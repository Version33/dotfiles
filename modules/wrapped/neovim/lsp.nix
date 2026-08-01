{ self, ... }:
{
  flake.modules.neovim.lsp =
    { lib, pkgs, ... }:
    let
      # The exact toolchain the system installs, so the editor's rust-analyzer
      # and the compiler that builds proc macros are always the same nightly.
      rust-toolchain = self.packages.${pkgs.stdenv.hostPlatform.system}.rust-toolchain;
    in
    {
      config.vim = {
        lsp = {
          enable = true;
          formatOnSave = false; # handled by conform.nvim
          inlayHints.enable = true; # LazyVim enables inlay hints by default

          servers.rust-analyzer = {
            # nvf points this at nixpkgs' stable-built rust-analyzer, whose
            # proc-macro server does not match a nightly rustc.
            cmd = lib.mkForce [ "${rust-toolchain}/bin/rust-analyzer" ];

            # Run the crate's strict [lints.clippy] policy as the on-save check,
            # so the deny list shows up as diagnostics without waiting on bacon.
            # `check.allTargets` already defaults to true, so tests are linted too.
            settings.rust-analyzer.check.command = "clippy";
          };
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
          rust = {
            enable = true;
            # Saecki/crates.nvim — versions, features and completion in Cargo.toml
            extensions.crates-nvim.enable = true;
          };
          go.enable = true;

          markdown.enable = true;
          yaml.enable = true;
        };

        # LazyVim diagnostic display config
        luaConfigRC.lsp-diagnostics = builtins.readFile ./lua/lsp-diagnostics.lua;
      };
    };
}
