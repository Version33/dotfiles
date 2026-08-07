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

      # git hosting on Freenet (github.com/freenet/freenet-git).
      # Ships the `freenet-git` CLI plus the `git-remote-freenet` helper,
      # so `git clone freenet::<key>/<name>` works against the local node.
      # Not in nixpkgs; built from crates.io.
      freenet-git = pkgs.rustPlatform.buildRustPackage rec {
        pname = "freenet-git";
        version = "0.1.24";
        src = pkgs.fetchCrate {
          inherit pname version;
          hash = "sha256-yPQoPsAKG8QWkc4cfgIs3nLA9yfhfWOV1E+qj0Z/RIo=";
        };
        cargoHash = "sha256-hupbPTQ9agtt8X3B4k9JcpWrOtN0KtSUshP6HieOQFw=";
        # Tests spawn real `git` to build fixture repos.
        nativeCheckInputs = [ pkgs.git ];
      };

      # Ghost Key CLI (crates.io/crates/ghostkey): anonymous credentials for
      # Freenet donors — verify/manage the certificate from ghostkey.net.
      ghostkey = pkgs.rustPlatform.buildRustPackage rec {
        pname = "ghostkey";
        version = "0.1.8";
        src = pkgs.fetchCrate {
          inherit pname version;
          hash = "sha256-3ibTZo63VNG/kJ5KkjXCliqrDSerbfq9IYfiVQz1+x4=";
        };
        cargoHash = "sha256-6ZKXG34XbzFOqnsyCLddWf7JS7kNTXJoR8ITQy4d9fU=";
      };
    in
    {
      # CLIs (`freenet network`, `freenet-git create`, `ghostkey verify`, ...)
      # plus the `git-remote-freenet` helper used by `git push freenet::...`.
      environment.systemPackages = [
        freenet
        freenet-git
        ghostkey
      ];

      # Peer identity/state lives under the user's XDG dirs (~/.local/share/freenet).
      # Remote access is via SSH tunnel (loopback source, always accepted
      # by the node's API source filter) — no extra CIDR allowances needed.
      systemd.user.services.freenet = {
        description = "Freenet peer";
        documentation = [ "https://freenet.org/quickstart/" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${freenet}/bin/freenet network";
          Restart = "on-failure";
          RestartSec = 10;
          # Don't restart-loop when the daemon exits asking for a flake update.
          RestartPreventExitStatus = 42;
        };
      };
    };
}
