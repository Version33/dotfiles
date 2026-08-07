_: {
  perSystem =
    { lib, pkgs, ... }:
    let
      pname = "feedback";

      # Tracking upstream's `nightly` channel, which is what got-feedback.org's
      # Linux download button serves.
      #
      # `nightly` is a *rolling* tag: GitHub re-uploads the same asset URL on
      # every nightly build, so this hash goes stale whenever upstream publishes.
      # That fails loudly at fetch time (hash mismatch), never silently — re-pin
      # by reading the asset's `digest` field from
      #   https://api.github.com/repos/got-feedback/feedBack-desktop/releases
      # which publishes the sha256 without downloading 552 MiB.
      #
      # For a reproducible pin instead, swap to the tagged release:
      #   version = "0.3.0-alpha.1";
      #   tag     = "v${version}";
      #   hash    = "sha256-vq8IqVE6uXr7SUMndAbxWEuGxq1PWnAsFkZxKmANX4M=";
      version = "0.3.0-nightly.20260722";
      tag = "nightly";
      hash = "sha256-5VvadJ26XQa+MjgFW8tnmA4Bzjc6ScMUpL8uEeGW7/Y=";

      # artifactName in upstream's electron-builder config is
      # `feedback-${version}-${arch}.${ext}`, where ${version} is the bare
      # package version (0.3.0) — not the channel or prerelease tag.
      src = pkgs.fetchurl {
        url = "https://github.com/got-feedback/feedBack-desktop/releases/download/${tag}/feedback-0.3.0-x86_64.AppImage";
        inherit hash;
      };

      appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
    in
    {
      packages.feedback = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # appimageTools' default FHS env already covers the Electron/Chromium
        # set plus alsa-lib, libjack2, libpulseaudio, pipewire, wayland,
        # libxkbcommon, vulkan-loader and udev — i.e. everything the JUCE audio
        # engine and MIDI device enumeration need. Only the gaps are listed here.
        extraPkgs =
          p: with p; [
            # libstdc++ for the bundled native .node addons, ONNX Runtime and
            # the out-of-process `slopsmith-vst-host`.
            stdenv.cc.cc.lib

            # Soundfont synthesis. Upstream bundles fluidsynth on Windows only
            # (.build-config.json has no fluidsynth_linux), so Linux resolves it
            # from the system.
            fluidsynth

            # The bundled CPython 3.12 tooling (stem separation, Retune's
            # pitch-shift) shells out to ffmpeg; ffmpeg-full carries the
            # librubberband filter that path wants.
            ffmpeg-full

            # python-build-standalone's _crypt module links libcrypt.so.1.
            libxcrypt-legacy

            # Electron desktop notifications.
            libnotify
          ];

        extraInstallCommands = ''
          # electron-builder emits exactly one .desktop at the AppImage root,
          # named after `executableName`. Glob it rather than hardcoding so an
          # upstream rename surfaces as a build error, not a missing launcher.
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
