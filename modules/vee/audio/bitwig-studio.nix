{ inputs, ... }:
{
  flake.modules.nixos.bitwig-studio =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.audio-nix.packages.${pkgs.stdenv.hostPlatform.system}.bitwig-studio6-latest
      ];
    };
}
