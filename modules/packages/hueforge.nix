{ inputs, ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      pname = "hueforge";

      # Proprietary paid download (shop.thehueforge.com), not redistributable, so
      # the AppImage lives outside git as a native `file+file://` flake input. To
      # update: replace it, bump version + URL in flake.nix, then
      # `nix flake update hueforge-bin`.
      version = "0.9.4.3";

      src = "${inputs.hueforge-bin}";

      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    {
      packages.hueforge = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # bwrap defaults to --die-with-parent, killing the app when the launcher's
        # short-lived spawn helper exits (niri/DMS).
        dieWithParent = false;

        # Qt's xcb plugin needs libxcb-cursor, which the default FHS env lacks.
        extraPkgs = p: [ p.libxcb-cursor ];
        extraInstallCommands = ''
          install -Dm444 ${contents}/HueForge.desktop \
            $out/share/applications/HueForge.desktop
          substituteInPlace $out/share/applications/HueForge.desktop \
            --replace-fail 'Exec=HueForge' 'Exec=${pname}'
          cp -r --no-preserve=mode ${contents}/usr/share/icons $out/share/
          install -Dm444 ${contents}/HueForge.png \
            $out/share/icons/hicolor/256x256/apps/HueForge.png
        '';

        meta = {
          description = "HueForge — filament color/height painting for 3D printing";
          homepage = "https://shop.thehueforge.com";
          license = lib.licenses.unfree;
          mainProgram = pname;
          platforms = [ "x86_64-linux" ];
        };
      };
    };
}
