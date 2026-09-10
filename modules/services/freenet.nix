{
  # Local peer; UI (e.g. River) at http://127.0.0.1:7509/.
  # Alpha network churns fast — old peers stop working. Binary is pinned;
  # run `nix flake update freenet` periodically (exits 42 to request this).
  flake.modules.nixos.freenet =
    { inputs, pkgs, ... }:
    let
      freenet = inputs.freenet.packages.${pkgs.stdenv.hostPlatform.system}.freenet;

      # git-remote-freenet helper enables `git clone freenet::<key>/<name>`.
      # Not in nixpkgs; built from crates.io.
      freenet-git = pkgs.rustPlatform.buildRustPackage rec {
        pname = "freenet-git";
        version = "0.1.27";
        src = pkgs.fetchCrate {
          inherit pname version;
          hash = "sha256-DE15vCrsf95ecVOGSHN1dn5eWMgQ7u0R1FvRv/fX3do=";
        };
        cargoHash = "sha256-ijIs6w0z4a8ENkXdTUIlBYIonkwjbj469nC9gD35fmk=";
        # Tests spawn real `git` to build fixture repos.
        nativeCheckInputs = [ pkgs.git ];
      };

      # Anonymous Freenet donor credentials; manage cert via ghostkey.net.
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

      # State lives under ~/.local/share/freenet. Remote access is via SSH
      # tunnel (loopback source; no extra CIDR allowlisting needed).
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
