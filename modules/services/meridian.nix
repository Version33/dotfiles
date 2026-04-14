{ inputs, ... }:
{

  flake.modules.nixos.meridian-service =
    { pkgs, ... }:
    let
      inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) meridian;
    in
    {
      environment.systemPackages = [ pkgs.claude-code ];

      systemd.user.services.meridian = {
        description = "meridian Claude Max proxy";
        path = [
          pkgs.claude-code
          pkgs.which
        ];
        serviceConfig = {
          ExecStart = "${meridian}/bin/meridian";
          Restart = "on-failure";
        };
      };
    };

}
