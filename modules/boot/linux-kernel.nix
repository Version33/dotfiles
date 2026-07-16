{

  flake.modules.nixos.linux-kernel =
    { pkgs, ... }:
    {
      # Linux Kernel
      boot = {
        kernel.sysctl."kernel.sysrq" = 1; # Enable all SysRq functions
        kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
        kernelParams = [
          "quiet"
          # "usbcore.autosuspend=-1"
          # Shorten USB enumeration timeout to reduce boot delay from broken internal port (usb3-7)
          "usbcore.initial_descriptor_timeout=5"
          # Disable ASPM on r8169 to prevent RTL8126 NIC sleep/wake issues
          "r8169.aspm=0"
        ];
      };

      security = {
        unprivilegedUsernsClone = true;
      };

    };

}
