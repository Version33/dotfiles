{
  flake.modules.nixos.tobiifree =
    {
      inputs,
      pkgs,
      config,
      lib,
      ...
    }:
    let
      tobiifreed = inputs.tobiifree.packages.x86_64-linux.tobiifreed.overrideAttrs (old: {
        nativeBuildInputs = [
          pkgs.zig_0_15
          pkgs.pkg-config
        ];
      });
      tobiifree-overlay = inputs.tobiifree.packages.x86_64-linux.tobiifree-overlay.overrideAttrs (old: {
        nativeBuildInputs = [
          pkgs.zig_0_15
          pkgs.pkg-config
        ];
      });
    in
    {
      # USB permissions for the Tobii Eye Tracker 5
      services.udev.extraRules = ''
        # Tobii Eye Tracker 5 (EyeChip) - bootloader mode
        SUBSYSTEM=="usb", ATTR{idVendor}=="2104", ATTR{idProduct}=="0102", MODE="0666", TAG+="uaccess"
        # Tobii Eye Tracker 5 (EyeChip) - runtime mode
        SUBSYSTEM=="usb", ATTR{idVendor}=="2104", ATTR{idProduct}=="0313", MODE="0666", TAG+="uaccess"
      '';

      # Install the daemon and overlay
      environment.systemPackages = [
        tobiifreed
        tobiifree-overlay
      ];

      # Starts automatically on login (wantedBy default.target); stop with
      # `systemctl --user stop tobiifreed` if the tracker is unplugged.
      systemd.user.services.tobiifreed = {
        description = "Tobii Eye Tracker 5 daemon";
        documentation = [ "https://github.com/Aetherall/tobiifree" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${tobiifreed}/bin/tobiifreed";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
}
