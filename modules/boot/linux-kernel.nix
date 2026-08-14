{

  flake.modules.nixos.linux-kernel =
    { pkgs, ... }:
    {
      # Linux Kernel
      boot = {
        kernel.sysctl."kernel.sysrq" = 1; # Enable all SysRq functions
        kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
        kernelModules = [ "ntsync" ]; # stops Ableton from sounding bad
        kernelParams = [
          "quiet"
          # "usbcore.autosuspend=-1"
          # Disable ASPM on r8169 to prevent RTL8126 NIC sleep/wake issues
          "r8169.aspm=0"
        ];
      };

      security = {
        unprivilegedUsernsClone = true;
      };

    };

}
