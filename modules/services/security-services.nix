{

  flake.modules.nixos.security-services =
    { pkgs, ... }:
    {

      security = {
        sudo-rs = {
          enable = true;
          execWheelOnly = true;
        };
        sudo.enable = false;
      };

      users.users.root.hashedPassword = "!";

      services = {
        fail2ban.enable = true;
        # open source antivirus https://www.clamav.net/
        clamav = {
          daemon.enable = true;
          scanner = {
            enable = true;
            interval = "Sat *-*-* 04:00:00";
          };
          fangfrisch = {
            enable = true;
            interval = "daily";
          };
          updater = {
            enable = true;
            interval = "daily"; # man systemd.time
            frequency = 12;
          };
        };
      };

      environment.systemPackages = with pkgs; [
        vulnix # scan command: vulnix --system
        clamav # scan command: sudo freshclam; clamscan [options] [file/directory/-]
      ];

    };

}
