{
  # Inputs are tack pins (.tack/pins.toml, locked in .tack/pins.lock.json);
  # manage them with `tack`, not `nix flake update`.
  #
  # HueForge is the exception: proprietary, paid, account-gated download from
  # shop.thehueforge.com. Not redistributable, so the AppImage stays outside git
  # at a machine-local path. tack can't pin a local single file, so it remains
  # a native flake input (locked in flake.lock). Bump by dropping the new
  # AppImage in place, updating this URL, then `nix flake update hueforge-bin`.
  inputs.hueforge-bin = {
    url = "file+file:///home/vee/Proprietary/hueforge/HueForge_Linux_v0.9.4.3.AppImage";
    flake = false;
  };

  outputs =
    { self, hueforge-bin, ... }:
    let
      inputs = import ./.tack // {
        inherit hueforge-bin;
        # flake-parts builds `inputs'` from `self.inputs`, which Nix only fills
        # with native inputs.
        self = self // {
          inherit inputs;
        };
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
