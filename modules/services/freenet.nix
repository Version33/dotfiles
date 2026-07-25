{
  # Freenet (freenet.org) peer-to-peer node.
  # Runs a local peer in the background; apps like River are served at
  # http://127.0.0.1:7509/ (see https://freenet.org/quickstart/).
  #
  # Alpha note: the network evolves fast and old peers stop working over
  # time. The binary is pinned by the flake input, so run
  # `nix flake update freenet` periodically (the service exits with code 42
  # when it wants a newer version).
  flake.modules.nixos.freenet =
    { inputs, pkgs, ... }:
    let
      freenet = inputs.freenet.packages.${pkgs.stdenv.hostPlatform.system}.freenet;
    in
    {
      # CLI (`freenet network`, `freenet service ...`)
      environment.systemPackages = [ freenet ];

      # Upstream's install.sh sets up a per-user unit; do the same declaratively.
      # Peer identity/state lives under the user's XDG dirs (~/.local/share/freenet).
      systemd.user.services.freenet = {
        description = "Freenet peer";
        documentation = [ "https://freenet.org/quickstart/" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          # Remote access is via SSH tunnel (loopback source, always accepted
          # by the node's API source filter) — no extra CIDR allowances needed.
          ExecStart = "${freenet}/bin/freenet network";
          Restart = "on-failure";
          RestartSec = 10;
        };
      };
    };
}
