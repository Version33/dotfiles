{ inputs, ... }:
{
  # github:shibco/ableton-linux — Ableton Live on Linux.
  # The runtime bundles the patched Wine (D2D1/DCOMP + NSPA, ntsync),
  # PipeASIO, the Link session anchor, and the `ableton-live` launcher.
  # It reuses the existing Wine prefix from testing; nothing here touches it.
  # Prefix maintenance stays on the flake apps, e.g.
  # `nix run github:shibco/ableton-linux#setup-prefix`.
  perSystem =
    { system, ... }:
    {
      packages.ableton-live = inputs.ableton-linux.packages.${system}.ableton-wine;
    };

  flake.modules.nixos.ableton = _: {
    # Ableton Link peer discovery. Upstream's setup-link.sh only knows
    # ufw/firewalld, so open the port declaratively instead.
    networking.firewall.allowedUDPPorts = [ 20808 ];
  };
}
