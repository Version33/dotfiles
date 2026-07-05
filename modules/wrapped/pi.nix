{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.pi = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.pi-coding-agent;
        envDefault = {
          PI_SKIP_VERSION_CHECK = "1";
          PI_TELEMETRY = "0";
        };
      };
    };
}
