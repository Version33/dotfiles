{

  flake.modules.nixos.vm = _: {
    # VM-specific configuration (only applies when building VMs with build-vm)
    virtualisation.vmVariant = {
      virtualisation = {
        # Configure available memory for the VM (in MB)
        memorySize = 8192; # 8GB - adjust as needed

        # Configure number of CPU cores for the VM
        cores = 8; # adjust based on your system

        # Configure disk size for the VM (in MB)
        diskSize = 20480; # 20GB - adjust as needed

        # Optional: use EFI boot in VM (recommended for testing secure boot setups)
        # useEFIBoot = true;

        # Optional: enable graphics acceleration in VM
        qemu.options = [
          "-device virtio-vga-gl"
          "-display gtk,gl=on"
        ];
      };
    };
  };

}
