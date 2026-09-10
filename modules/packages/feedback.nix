{ inputs, ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      pname = "feedback";

      # `nightly` is a rolling GitHub tag (same asset URL re-uploaded); the
      # file+https input pins a snapshot in flake.lock. Bump with
      # `nix flake update feedback-nightly`.
      version = "0.3.0-nightly";

      src = "${inputs.feedback-nightly}";

      appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    {
      packages.feedback = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # appimageTools' default FHS env already covers Electron + audio/MIDI libs.
        extraPkgs =
          p: with p; [
            # bundled native .node addons, ONNX Runtime, slopsmith-vst-host
            stdenv.cc.cc.lib

            # upstream bundles fluidsynth on Windows only
            fluidsynth

            # bundled Python tooling shells out to ffmpeg with librubberband filter
            ffmpeg-full

            # python-build-standalone's _crypt module links libcrypt.so.1.
            libxcrypt-legacy

            # Electron desktop notifications.
            libnotify
          ];

        extraInstallCommands = ''
          # Glob the single electron-builder .desktop so a rename fails the build.
          install -Dm444 ${appimageContents}/*.desktop \
            $out/share/applications/${pname}.desktop

          # AppRun only exists inside the mounted image; point at the wrapper.
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace-fail 'Exec=AppRun' 'Exec=${pname}'

          cp -r ${appimageContents}/usr/share/icons $out/share/
        '';

        meta = {
          description = "Open-source rhythm gaming and music education platform";
          longDescription = ''
            fee[dB]ack is a multi-instrument rhythm game and practice tool —
            guitar, bass, drums, keys and vocals — built on an Electron shell
            around a native JUCE audio engine with real-time note detection,
            VST hosting and amp modeling.
          '';
          homepage = "https://got-feedback.org";
          downloadPage = "https://github.com/got-feedback/feedBack-desktop/releases";
          license = lib.licenses.agpl3Only;
          mainProgram = pname;
          platforms = [ "x86_64-linux" ];
        };
      };
    };
}
