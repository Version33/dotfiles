_: {
  perSystem =
    { pkgs, ... }:
    let
      # Bambu H2C/A2L support (PR #14685) is merged to main but not in any
      # tagged release (latest: v2.4.2) — use the nightly AppImage until the
      # next stable release ships. Bump with `nix run .#orca-nightly-update`.
      # Upstream overwrites the nightly asset in place, so the hash pins a
      # specific snapshot; the fetch only re-runs when the hash is bumped.
      version = "nightly-2026-08-22";
      hash = "sha256-q3DlRqaxOPe0cDL2W2kuQzkHQsTf9zOO1WEwYmDKzfw=";

      pname = "orca-slicer";
      src = pkgs.fetchurl {
        url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/nightly-builds/OrcaSlicer_Linux_AppImage_Ubuntu2404_nightly.AppImage";
        inherit hash;
      };

      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    {
      packages.orca-slicer = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # bwrap defaults to --die-with-parent, which kills the app the moment
        # a launcher's short-lived spawn helper exits (niri/noctalia). The
        # terminal case only worked because the shell stayed alive as parent.
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

          # Orca probes the Fedora CA path (/etc/pki/...) and warns on NixOS;
          # point it at the real system bundle instead.
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

      # Refreshes `hash` above to the current nightly AppImage snapshot.
      packages.orca-nightly-update = pkgs.writeShellApplication {
        name = "orca-nightly-update";
        runtimeInputs = with pkgs; [
          curl
          jq
          nix
        ];
        text = ''
          asset=$(curl -fsSL https://api.github.com/repos/OrcaSlicer/OrcaSlicer/releases/tags/nightly-builds \
            | jq -r '.assets[] | select(.name == "OrcaSlicer_Linux_AppImage_Ubuntu2404_nightly.AppImage")')
          digest=$(jq -r '.digest' <<<"$asset" | cut -d: -f2)
          date=$(jq -r '.updated_at' <<<"$asset" | cut -dT -f1)
          sri=$(nix hash convert --hash-algo sha256 --to sri "$digest")
          file=modules/wrapped/orca-slicer.nix
          sed -i \
            -e "s|version = \"nightly-.*\";|version = \"nightly-$date\";|" \
            -e "s|hash = \"sha256-.*\";|hash = \"$sri\";|" \
            "$file"
          echo "orca-slicer nightly pinned to $date ($sri)"
        '';
      };
    };
}
