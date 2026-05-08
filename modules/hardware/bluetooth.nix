{

  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      environment.systemPackages = with pkgs; [
        overskride
      ];
    };

}
