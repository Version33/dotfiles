{
  # `tack update` has no hook mechanism
  perSystem =
    {
      pkgs,
      self',
      inputs',
      ...
    }:
    {
      packages.update = pkgs.writeShellApplication {
        name = "update";
        runtimeInputs = [
          pkgs.nix
          inputs'.tack.packages.tack
        ];
        text = ''
          if token=$(gh auth token 2>/dev/null); then
            export GITHUB_TOKEN="$token"
          fi
          tack update
          ${self'.packages.godot-dev-update}/bin/godot-dev-update
        '';
      };
    };
}
