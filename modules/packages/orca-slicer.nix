{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # Bambu H2C/A2L support (PR #14685) merged to main but not yet in a
      # tagged release (latest: v2.4.2); nightly AppImage until it ships.
      # Upstream overwrites the asset in place — `nix flake update orca-nightly`.
      version = "nightly";

      pname = "orca-slicer";
      src = "${inputs.orca-nightly}";

      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    {
      packages.orca-slicer = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # bwrap defaults to --die-with-parent, killing the app when the launcher's
        # helper exits (niri/noctalia) — terminal launches "worked" only by accident.
        dieWithParent = false;

        extraPkgs =
          pkgs: with pkgs; [
            webkitgtk_4_1
            libsoup_3
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
          source ${pkgs.makeWrapper}/nix-support/setup-hook
          wrapProgram $out/bin/${pname} \
            --set-default SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt
        '';
        meta = {
          description = "OrcaSlicer nightly (Bambu H2C support)";
          homepage = "https://github.com/OrcaSlicer/OrcaSlicer";
          mainProgram = pname;
        };
      };

    };
}
