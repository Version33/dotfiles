{ inputs, self, ... }:
{
  # Standalone: nix run .#neovim
  perSystem =
    { pkgs, theme, ... }:
    {
      packages.neovim =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          # nvf has its own module system; `theme` doesn't reach it otherwise.
          extraSpecialArgs = { inherit theme; };
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
