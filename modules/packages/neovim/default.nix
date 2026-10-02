{ inputs, self, ... }:
{
  # Standalone: nix run .#neovim
  perSystem =
    { pkgs, ... }:
    {
      packages.neovim =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = builtins.attrValues self.modules.neovim;
        }).neovim;
    };

  # System: auto-imported via flake.modules.nixos
  flake.modules.nixos.neovim =
    { self, pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
      ];
      environment.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
}
