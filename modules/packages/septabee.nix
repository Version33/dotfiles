{ inputs, ... }:
{
  flake.modules.nixos.septabee =
    { pkgs, ... }:
    let
      # Upstream's versions.nix only knows hashes up to B_T15. Pin newer builds
      # here by overriding src on its latest package (keeps upstream's patchelf
      # deps, .desktop and icon). To bump: `nix store prefetch-file <url>`,
      # update version + hash. Drop this override once upstream catches up.
      version = "B_T16_offline";
      hash = "sha256-1cimDVeFf/DODIi1qamUKhKrze8/ReceK/iUHqlpKuM=";
    in
    {
      imports = [ inputs.septabee.nixosModules.default ];

      # Installs the package and wraps septabee/septabee-sounds with
      # cap_sys_nice for realtime audio scheduling.
      programs.septabee = {
        enable = true;
        package = inputs.septabee.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {
          name = "septabee-${version}";
          inherit version;
          src = pkgs.fetchurl {
            url = "https://septabee.nekoweb.org/important_stuff/SEPTABEE_DOWNLOADS/version_B/septabee_linux_${version}.7z";
            inherit hash;
          };
        };
      };
    };
}
