{
  perSystem =
    { lib, pkgs, ... }:
    {
      # Disable bwrap --die-with-parent so noctalia's short-lived spawn helper
      # doesn't kill osu on exit (same fix as orca-slicer).
      packages.osu-lazer-bin = pkgs.osu-lazer-bin.override {
        appimageTools = pkgs.appimageTools // {
          wrapType2 =
            args:
            pkgs.appimageTools.wrapType2 (
              finalAttrs: (if lib.isFunction args then args finalAttrs else args) // { dieWithParent = false; }
            );
        };
      };
    };
}
