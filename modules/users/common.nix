{
  flake.modules.nixos.users-common =
    { self, pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      environment.shells = [
        self.packages.${system}.fish
      ];

      security.pam.loginLimits = [
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "nice";
          type = "-";
          value = "-19";
        }
      ];

      systemd.user.services.steam-desktop-fix = {
        description = "Ensure Steam desktop entry uses the keepalive launcher";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = toString (
            pkgs.writeShellScript "steam-desktop-fix" ''
              mkdir -p "$HOME/.local/share/applications"
              cp -f ${self.packages.${system}.steam-desktop-item}/share/applications/steam.desktop \
                "$HOME/.local/share/applications/steam.desktop"
            ''
          );
        };
      };

      systemd.user.services.evo-control-preset = {
        description = "Load EVO 8 mixer preset on login";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          TimeoutStartSec = 5;
          ExecStart = toString (
            pkgs.writeShellScript "evo-control-preset" ''
              mkdir -p "$HOME/.config/evo-control/presets"
              cp -f /etc/evo-control/presets/main.toml "$HOME/.config/evo-control/presets/main.toml"
              evo-control preset load main || true
            ''
          );
        };
      };
    };
}
