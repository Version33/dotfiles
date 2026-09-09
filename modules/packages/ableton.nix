{ inputs, ... }:
{
  # github:shibco/ableton-linux — Ableton Live on Linux.
  # The runtime bundles the patched Wine (D2D1/DCOMP + NSPA, ntsync),
  # PipeASIO, the Link session anchor, and the `ableton-live` launcher.
  # It reuses the existing Wine prefix from testing; nothing here touches it.
  # Prefix maintenance stays on the flake apps, e.g.
  # `nix run github:shibco/ableton-linux#setup-prefix`.
  perSystem =
    { pkgs, system, ... }:
    let
      ableton-wine = inputs.ableton-linux.packages.${system}.ableton-wine;
    in
    {
      # Upstream ships a generic "Ableton Live" menu entry for every edition;
      # rebrand the visible one to the installed edition (Suite). The shipped
      # live-suite icon is already the Suite artwork. NoDisplay MIME/protocol
      # entries keep their generic name. StartupWMClass groups Live's Wine
      # windows under this entry.
      packages.ableton-live = pkgs.symlinkJoin {
        name = ableton-wine.name;
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
    # Ableton Link peer discovery. Upstream's setup-link.sh only knows
    # ufw/firewalld, so open the port declaratively instead.
    networking.firewall.allowedUDPPorts = [ 20808 ];
  };
}
