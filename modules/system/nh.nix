{
  flake.modules.nixos.nh = _: {
    # nh — nix-community/nh: a nicer CLI wrapper around nixos-rebuild that
    # bundles nom (build output) and nvd (closure diff) automatically.
    programs.nh = {
      enable = true;

      # Default flake for `nh os` actions (sets NH_FLAKE). Lets `nh os switch`
      # run from anywhere without pointing at the repo.
      flake = "/home/vee/nixos";

      # Periodic GC via `nh clean all` — replaces nix.gc.automatic (the two
      # conflict; see the warning in nixpkgs' programs.nh module).
      clean = {
        enable = true;
        dates = "weekly";
        # always keep the 3 most recent builds
        extraArgs = "--keep-since 14d --keep 3";
      };
    };
  };
}
