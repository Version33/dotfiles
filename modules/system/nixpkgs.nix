{ inputs, ... }:
{

  flake.modules.nixos.nixpkgs = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };

  # Configure perSystem pkgs (separate from NixOS module system pkgs)
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        localSystem = system;
        config.allowUnfree = true;
      };
    };

}
