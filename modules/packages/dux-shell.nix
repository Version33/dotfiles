{
  perSystem =
    { pkgs, ... }:
    {
      # WORKAROUND(dux-shell-patches): unquoted KDL names + QR without network backend — see WORKAROUNDS.md
      packages.dux-shell = pkgs.dux-shell.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./dux-shell-niri-unquote-names.patch
          ./dux-shell-qrcode-without-network-manager.patch
        ];
      });
    };
}
