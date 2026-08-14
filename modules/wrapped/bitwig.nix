{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      # 6-latest tracks betas, which carry an expiry time bomb; use stable.
      # audio-nix's stable is behind upstream (6.0.6), so bump the source to
      # the current stable release and re-wrap with its bubblewrap wrapper.
      # Drop this override once audio-nix catches up.
      version = "6.0.11";
      unwrapped =
        inputs.audio-nix.packages.${system}.bitwig-studio6-0-unwrapped.overrideAttrs
          (old: {
            inherit version;
            src = pkgs.fetchurl {
              url = "https://downloads-secure.bitwig.com/${version}/bitwig-studio-${version}.deb?source_url=/dl/Bitwig%20Studio/${version}/installer_linux/";
              sha256 = "sha256-rnr/Z8y6klKrU2gT5/XT+sRryl/HZZZ04n565L0HPEw=";
            };
          });
      bitwig = pkgs.callPackage (inputs.audio-nix + "/bitwig/bitwig-bubblewrap.nix") {
        bitwig-studio = unwrapped;
      };

      # Third-party plugin binaries (e.g. Serum 2) are dlopen'd by Bitwig's
      # plugin host and resolve their dependencies through the process's
      # LD_LIBRARY_PATH. The audio-nix wrapper only provides Bitwig's own
      # dependencies, so plugins needing anything beyond that fail with
      # "libSM.so.6: cannot open shared object file". These are the libs
      # Serum 2 links that Bitwig's wrapper doesn't already ship.
      pluginLibs = with pkgs; [
        libsm
        libice
        libxext
        xcb-util-cursor
        libxcb-keysyms
        fontconfig
        expat
        openssl
        curl
      ];
    in
    {
      # The inner audio-nix wrapper uses `--suffix LD_LIBRARY_PATH`, so the
      # env set here survives bubblewrap and ends up ahead of Bitwig's own
      # paths; both come from the same nixpkgs, so ordering is harmless.
      # The desktop entry launches plain `bitwig-studio` via PATH, so it
      # picks up this wrapper too.
      packages.bitwig-studio = pkgs.symlinkJoin {
        name = "bitwig-studio-${bitwig.version}";
        paths = [ bitwig ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          rm $out/bin/bitwig-studio
          makeWrapper ${bitwig}/bin/bitwig-studio $out/bin/bitwig-studio \
            --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath pluginLibs}
        '';
      };
    };
}
