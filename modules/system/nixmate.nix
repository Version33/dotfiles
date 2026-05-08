{ inputs, ... }:
{
  flake.modules.nixos.nixmate =
    { pkgs, ... }:
    {
      # Install nixmate - comprehensive NixOS TUI manager
      # Provides unified interface for: generations, rebuilds, services,
      # error translation, storage management, package search, and more
      environment.systemPackages = [
        inputs.nixmate.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
