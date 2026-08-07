{

  flake.modules.nixos.graphics = {
    # Enable GPU acceleration. mesa (the default hardware.graphics.package)
    # already provides the AMD VA-API driver (radeonsi_drv_video.so) and
    # native VDPAU for this all-amdgpu system, so no extraPackages are
    # needed. enable32Bit is kept for Steam.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

}
