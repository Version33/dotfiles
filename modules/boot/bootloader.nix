{

  flake.modules.nixos.bootloader = _: {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10; # Keep last 10 NixOS generations
          consoleMode = "max"; # Better resolution for boot menu
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        timeout = 2;
      };

      initrd.verbose = false;
      consoleLogLevel = 5;
    };
  };

}
