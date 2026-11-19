{

  flake.modules.nixos.linux-kernel =
    { pkgs, lib, ... }:
    {
      # Linux Kernel
      boot = {
        kernel.sysctl."kernel.sysrq" = 1; # Enable all SysRq functions
        # WORKAROUND(xanmod-128bit-patch): drop a nixpkgs kernel patch already in 7.3 — see WORKAROUNDS.md
        kernelPackages = pkgs.linuxKernel.packagesFor (
          pkgs.linuxKernel.kernels.linux_xanmod_latest.override (old: {
            kernelPatches = lib.filter (
              p: p.name != "tools-add-128-bit-integer-types-for-aarch64"
            ) old.kernelPatches;
          })
        );
        kernelParams = [
          "quiet"
          # "usbcore.autosuspend=-1"
        ];
      };
    };

}
