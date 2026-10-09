{
  perSystem =
    { pkgs, ... }:
    {
      # The niri keybind parser compares node names via Value.String(), which
      # keeps KDL quotes, so the quoted names emitted by wrapper-modules'
      # toKdl ("binds", "Mod+Q", "close-window") never match. Use the unquoted
      # form. Drop once upstreamed.
      packages.dms-shell = pkgs.dms-shell.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./dms-shell-niri-unquote-names.patch ];
      });
    };
}
