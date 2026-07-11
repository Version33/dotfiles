{ inputs, ... }:
{
  # Secure boot support
  flake.modules.nixos.secure-boot =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
      ];

      environment.systemPackages = [
        pkgs.sbctl # For debugging and troubleshooting Secure Boot.
      ];

      # Lanzaboote requires disabling the default systemd-boot loader
      boot.loader.systemd-boot.enable = lib.mkForce false;

      # Enable and configure Lanzaboote
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        # systemd-boot's configurationLimit is dead once lanzaboote takes over;
        # without this, every retained generation's kernel+initrd is copied to the ESP.
        configurationLimit = 10;
      };
    };

}
