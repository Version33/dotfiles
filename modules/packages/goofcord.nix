{
  perSystem =
    { pkgs, ... }:
    let
      # Chromium's WebRtcAllowInputVolumeAdjustment feature lets the WebRTC AGC
      # write the *system* source volume; against the EVO8 it ratchets the mic
      # down (1.00 -> 0.56 in ~25s) and never recovers. Discord's own AGC toggle
      # does not disable it. Cannot be a wrapper flag: GoofCord's startup calls
      # appendSwitch("disable-features", ...) which replaces any argv value, so
      # patch its list in app.asar. --replace-fail turns an upstream reshape of
      # that call into a build error instead of a silent regression.
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
            # --no-preserve=mode would strip exec bits from the launcher and patchcord.
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
