{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      bitwig = inputs.audio-nix.packages.${system}.bitwig-studio6-latest;

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
