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
          daemon.enable = false;
          scanner = {
            enable = false;
            interval = "Sat *-*-* 04:00:00";
          };
          fangfrisch = {
            enable = false;
            interval = "daily";
          };
          updater = {
            enable = false;
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
