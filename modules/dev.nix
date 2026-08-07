{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt;
        settings.excludes = [ "hardware-configuration.nix" ];
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          # Nix development tools
          nixd # Nix language server
          nixfmt # Nix formatter
          statix # Lints and suggestions for Nix code
          deadnix # Find and remove unused code
          nix-tree # Visualize dependency tree
          nix-output-monitor # Better build output (alias: nom)

          # Useful utilities
          just # Command runner (for justfile)
        ];
      };
    };
}
