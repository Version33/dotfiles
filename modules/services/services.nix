{
  flake.modules.nixos.services =
    { pkgs, ... }:
    {
      programs = {
        dconf.enable = true;
        xfconf.enable = true; # Xfce configuration storage system
      };

      services = {
        dbus = {
          enable = true;
          implementation = "broker";
        };
        tumbler.enable = true; # D-Bus thumbnailer service
        fwupd.enable = true; # firmware updates over D-Bus
      };

      # Alert on system resource saturation (PSI).
      systemd.packages = [ pkgs.psi-notify ];
      systemd.user.services.psi-notify.wantedBy = [ "default.target" ];

      hardware.opentabletdriver.enable = true;
    };
}
