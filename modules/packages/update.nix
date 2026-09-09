{
  # `nix flake update` has no hook mechanism
  perSystem =
    { pkgs, self', ... }:
    {
      packages.update = pkgs.writeShellApplication {
        name = "update";
        runtimeInputs = [ pkgs.nix ];
        text = ''
          if token=$(gh auth token 2>/dev/null); then
            export NIX_CONFIG="access-tokens = github.com=$token"
          fi
          nix flake update
          ${self'.packages.godot-dev-update}/bin/godot-dev-update
        '';
      };
    };
}
