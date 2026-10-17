{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # Tagged release AppImage (first release with Bambu H2C/A2L support).
      # Bump: edit the URL in modules/flake.nix, then `nix flake update orca-slicer`.
      version = "2.5.0-alpha";

      pname = "orca-slicer";
      src = "${inputs.orca-slicer}";

      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    {
      packages.orca-slicer = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # bwrap defaults to --die-with-parent, killing the app when the launcher's
        # helper exits (niri/DMS) — terminal launches "worked" only by accident.
        dieWithParent = false;

        extraPkgs =
          pkgs: with pkgs; [
            webkitgtk_4_1
            libsoup_3
            glib-networking # GIO TLS backend; without it the WebKit login popup says "TLS support is not available"
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-libav
          ];

        extraInstallCommands = ''
          install -Dm444 ${contents}/com.orcaslicer.OrcaSlicer.desktop \
            $out/share/applications/OrcaSlicer.desktop
          substituteInPlace $out/share/applications/OrcaSlicer.desktop \
            --replace-fail 'Exec=AppRun' 'Exec=${pname}'
          cp -r --no-preserve=mode ${contents}/usr/share/icons $out/share/
          install -Dm444 ${contents}/OrcaSlicer.png \
            $out/share/icons/hicolor/256x256/apps/OrcaSlicer.png

          # Orca probes the Fedora CA path (/etc/pki/...); point at the NixOS bundle instead.
          # GIO_EXTRA_MODULES: libsoup/WebKit only find the gnutls backend via this path.
          source ${pkgs.makeWrapper}/nix-support/setup-hook
          wrapProgram $out/bin/${pname} \
            --set-default SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
            --prefix GIO_EXTRA_MODULES : ${pkgs.glib-networking}/lib/gio/modules
        '';
        meta = {
          description = "OrcaSlicer ${version} (Bambu H2C support)";
          homepage = "https://github.com/OrcaSlicer/OrcaSlicer";
          mainProgram = pname;
        };
      };

    };
}
