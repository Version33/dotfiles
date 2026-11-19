{
  perSystem =
    { pkgs, ... }:
    {
      # WORKAROUND(dux-shell-patches): unquoted KDL names — see WORKAROUNDS.md
      packages.dux-shell = pkgs.dux-shell.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./dux-shell-niri-unquote-names.patch
        ];
      });
    };
}
