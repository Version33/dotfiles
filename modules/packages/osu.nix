{
  perSystem =
    { lib, pkgs, ... }:
    {
      # WORKAROUND(osu-diewithparent): DMS spawn helper exit would kill osu — see WORKAROUNDS.md
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
