{
  perSystem =
    { pkgs, ... }:
    {
      # - niri-unquote-names: the keybind parser compares node names via
      #   Value.String(), which keeps KDL quotes, so the quoted names emitted
      #   by wrapper-modules' toKdl ("binds", "Mod+Q", "close-window") never
      #   match. Use the unquoted form.
      # - qrcode-without-network-manager: the router rejects every network.*
      #   call when the network backend failed to initialize (here: iwd runs
      #   but the host has no WiFi device), which also killed the text QR
      #   generator that never touches the backend.
      # Drop each once upstreamed.
      packages.dux-shell = pkgs.dux-shell.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./dux-shell-niri-unquote-names.patch
          ./dux-shell-qrcode-without-network-manager.patch
        ];
      });
    };
}
