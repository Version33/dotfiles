{
  perSystem =
    { pkgs, ... }:
    let
      # Chromium's WebRTC stack owns the *system* capture volume by default:
      # `media/webrtc/helpers.cc` wires
      # `gain_controller2.input_volume_controller.enabled` straight to the
      # `WebRtcAllowInputVolumeAdjustment` feature (enabled by default), and its
      # recommendations land in `PulseAudioInputStream::SetVolume` ->
      # `pa_context_set_source_volume_by_index`. Against the EVO8 that means every
      # loud syllable ratchets the PipeWire source volume down (1.00 -> 0.82 ->
      # 0.78 -> 0.56 ...) and it never climbs back, so the mic dies over a session.
      #
      # Discord's own "Automatic Gain Control" toggle does *not* stop this —
      # measured with it off, the volume still walked down to 0.56 in 25s. Only
      # killing the Chromium feature works: SIGSTOPping GoofCord's audio service
      # pinned the source at 1.00 under shouting, and nothing else on the graph
      # (Steam voice, Deadlock) touches it.
      #
      # It cannot be a wrapper flag. GoofCord's startup calls
      # `app.commandLine.appendSwitch("disable-features", <its own list>)`, and
      # appendSwitch *replaces* the value, so any `--disable-features` we pass on
      # argv is silently dropped before the audio service is spawned (verified:
      # the flag reached the browser process, not the utility child). So patch its
      # set instead — that also preserves GoofCord's settings-driven VA-API and
      # performance switches, which `--no-flags` would throw away.
      #
      # `--replace-fail` makes a GoofCord update that reshapes this call a build
      # error rather than a silent regression back to a dying microphone.
      goofcordDisabledFeatures = ''"MediaSessionService","HardwareMediaKeyHandling"'';
    in
    {
      packages.goofcord =
        pkgs.runCommand "goofcord-${pkgs.goofcord.version}"
          {
            nativeBuildInputs = [ pkgs.asar ];
            inherit (pkgs.goofcord) meta;
          }
          ''
            # Keep the source modes — dropping them would strip the exec bit off
            # the launcher and `patchcord` — and only add write access to edit.
            cp -r --no-preserve=ownership ${pkgs.goofcord} $out
            chmod -R u+w $out
            resources=$out/share/lib/goofcord/resources

            asar extract $resources/app.asar app
            substituteInPlace app/ts-out/main.js \
              --replace-fail '${goofcordDisabledFeatures}' \
                '${goofcordDisabledFeatures},"WebRtcAllowInputVolumeAdjustment"'
            rm $resources/app.asar
            asar pack app $resources/app.asar

            # The launcher hardcodes the unpatched store path to app.asar.
            substituteInPlace $out/bin/goofcord \
              --replace-fail '${pkgs.goofcord}/share/lib/goofcord/resources/app.asar' \
                "$resources/app.asar"
          '';
    };
}
