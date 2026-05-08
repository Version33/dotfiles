{ inputs, ... }:
{
  flake-file.inputs.audio-nix.url = "github:polygon/audio.nix";

  flake.modules.nixos.bitwig-studio =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.audio-nix.packages.${pkgs.stdenv.hostPlatform.system}.bitwig-studio6-latest
      ];
    };
}
