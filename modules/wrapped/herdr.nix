{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      configFile = pkgs.writeText "herdr-config.toml" ''
        [theme]
        name = "catppuccin"
      '';
    in
    {
      packages.herdr = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.herdr;
        envDefault = {
          HERDR_CONFIG_PATH = toString configFile;
        };
      };
    };
}
