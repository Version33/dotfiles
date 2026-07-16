{

  flake.modules.nixos.bootloader = _: {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10; # Keep last 10 NixOS generations
          # Allow rebooting to firmware/UEFI settings from boot menu
          consoleMode = "max"; # Better resolution for boot menu
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        timeout = 2;
      };

      # Quiet boot: suppress stage-1 chatter and emit the loglevel=5 kernel
      # param (an explicit consoleLogLevel wins over the default's loglevel=4,
      # which would otherwise override a hand-written param).
      initrd.verbose = false;
      consoleLogLevel = 5;
    };
  };

}
