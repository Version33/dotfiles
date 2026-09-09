{
  # `nix develop` — Nix authoring tools, not installed system-wide.
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd # Nix language server
          nixfmt # Nix formatter
          statix # Lints and suggestions for Nix code
          deadnix # Find and remove unused code
          nix-tree # Visualize dependency tree
          nix-output-monitor # Better build output (alias: nom)
          just # Command runner (for justfile)
        ];
      };
    };
}
