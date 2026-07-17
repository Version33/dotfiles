{
  flake.modules.nixos.yabridge =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        yabridge
        yabridgectl
      ];
    };
}
