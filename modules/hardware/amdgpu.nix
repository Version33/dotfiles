{

  flake.modules.nixos.amdgpu = {
    # Load AMD GPU driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.amdgpu = {
      # https://search.nixos.org/options?channel=unstable&query=hardware.amdgpu
      overdrive.enable = false; # overclocking

      # Enable OpenCL (for compute tasks)
      # opencl.enable = true;
    };

    # LACT: GPU monitoring/configuration daemon. Settings are declarative, so
    # the GUI can read but not save; edit here instead.
    services.lact = {
      enable = true;
      settings = {
        version = 7;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        gpus = {
          # RX 9070 XT; id from `lact cli list-gpus`. Default cap is 304 W,
          # hardware maximum (power1_cap_max) is 340 W.
          "1002:7550-1EAE:8811-0000:03:00.0" = {
            power_cap = 340.0;
          };
        };
      };
    };

    # Add ROCm for AI/ML workloads
    # systemd.tmpfiles.rules = [
    #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    # ];

    # # Make ROCm accessible to all users (using hardware.graphics, not deprecated hardware.opengl)
    # hardware.graphics.extraPackages = with pkgs; [
    #   rocmPackages.clr.icd
    #   rocmPackages.clr
    #   rocmPackages.rocm-runtime
    #   libdrm
    # ];
  };

}
