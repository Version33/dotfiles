{

  flake.modules.nixos.rgb =
    { pkgs, ... }:
    {
      # Install OpenRGB
      environment.systemPackages = with pkgs; [
        openrgb
      ];

      # Enable OpenRGB service (sets up udev rules automatically)
      services.hardware.openrgb.enable = true;
    };

}
