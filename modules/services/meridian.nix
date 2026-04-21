{ inputs, ... }:
{
  flake-file.inputs.meridian.url = "github:rynfar/meridian";

  flake.modules.nixos.meridian-service =
    { pkgs, ... }:
    let
      meridian = inputs.meridian.packages.${pkgs.stdenv.hostPlatform.system}.meridian;
    in
    {
      environment.systemPackages = [ pkgs.claude-code ];

      systemd.user.services.meridian = {
        description = "Meridian — local Anthropic API proxy";
        wantedBy = [ "default.target" ];
        path = [
          pkgs.claude-code
          pkgs.which
        ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${meridian}/bin/meridian";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
}
