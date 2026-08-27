{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.starship = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.starship;
        # envDefault, so an explicit STARSHIP_CONFIG still overrides this.
        envDefault = {
          STARSHIP_CONFIG = toString ./starship.toml;
        };
      };
    };
}
