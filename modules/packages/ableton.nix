{ inputs, ... }:
{
  # Wine prefix is managed by the upstream flake apps, e.g.
  # `nix run github:shibco/ableton-linux#setup-prefix`.
  perSystem =
    { pkgs, system, ... }:
    let
      ableton-wine = inputs.ableton-linux.packages.${system}.ableton-wine;
    in
    {
      # Upstream ships one generic "Ableton Live" entry for every edition;
      # rename the visible one to Suite and group its Wine windows under it.
      packages.ableton-live = pkgs.symlinkJoin {
        inherit (ableton-wine) name;
        paths = [ ableton-wine ];
        postBuild = ''
          entry=$out/share/applications
          for f in $entry/*.desktop; do
            if grep -q '^Comment=Music production and performance' "$f"; then
              sed -i -e 's/^Name=Ableton Live$/Name=Ableton Live 12 Suite/' \
                     -e '$a StartupWMClass=ableton live 12 suite.exe' "$f"
            fi
          done
        '';
      };
    };

  flake.modules.nixos.ableton = _: {
    # ntsync has no modalias, so nothing autoloads it; without it the patched
    # wineserver falls back to the slow server-side path and audio stutters.
    boot.kernelModules = [ "ntsync" ];
    # Ableton Link peer discovery.
    # networking.firewall.allowedUDPPorts = [ 20808 ];
  };
}
