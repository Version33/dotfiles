{
  perSystem =
    { pkgs, ... }:
    let
      # Chromium's WebRtcAllowInputVolumeAdjustment feature lets the WebRTC AGC
      # write the *system* source volume. Disable that.
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
