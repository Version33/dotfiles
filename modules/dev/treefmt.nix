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
        settings.excludes = [
          "hardware-configuration.nix"
          ".tack/default.nix" # tack-managed resolver; reformatting it blocks `tack init --resolver`
        ];
      };
    };
}
