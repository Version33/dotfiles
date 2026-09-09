{ inputs, ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      pname = "hueforge";

      # Proprietary, paid, account-gated download from shop.thehueforge.com.
      # Not redistributable, so the AppImage lives outside git at a machine-local
      # path and is pulled in as a `file+file://` flake input (flake.lock pins a
      # snapshot narHash). To update: drop the new AppImage next to the old one,
      # bump both the version here and the URL in modules/flake.nix, then
      # `nix run .#write-flake && nix flake lock`.
      version = "0.9.4.3";

      src = "${inputs.hueforge-bin}";

      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    {
      packages.hueforge = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # bwrap defaults to --die-with-parent, which kills the app the moment a
        # launcher's short-lived spawn helper exits (niri/noctalia). Same fix as
        # orca-slicer.
        dieWithParent = false;

        # The AppImage deliberately omits host-driver-tied libraries (see its
        # README): the XCB cursor lib and the Vulkan loader. appimageTools' FHS
        # env already carries the rest of the xcb/xkbcommon set the bundled Qt
        # xcb platform plugin needs.
        extraPkgs =
          p: with p; [
            libxcb-cursor # libxcb-cursor.so.0 — required by Qt xcb plugin
            vulkan-loader # libvulkan.so.1 — only if the Vulkan backend is selected
          ];
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
