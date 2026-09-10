{

  flake.modules.nixos.graphics = {
    # Enable GPU acceleration.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

}
