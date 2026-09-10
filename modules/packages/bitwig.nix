{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      # audio-nix lags upstream: its 6-0 attr is 6.0.6 and 6-1 is still the
      # time-bombed 6.1-beta-1; bump the source to the 6.1 release and re-wrap.
      # Drop once audio-nix catches up.
      version = "6.1.1";
      unwrapped = inputs.audio-nix.packages.${system}.bitwig-studio6-1-unwrapped.overrideAttrs (old: {
        inherit version;
        src = pkgs.fetchurl {
          url = "https://downloads-secure.bitwig.com/${version}/bitwig-studio-${version}.deb?source_url=/dl/Bitwig%20Studio/${version}/installer_linux/";
          sha256 = "sha256-FBe0R6YW4IS1OPvCwWseQvJnn7OrPn1uZ0v/GKRIIYE=";
        };
      });
      bitwig = pkgs.callPackage (inputs.audio-nix + "/bitwig/bitwig-bubblewrap.nix") {
        bitwig-studio = unwrapped;
      };

      # Third-party plugins (Serum 2) are dlopen'd and resolve via the process
      # LD_LIBRARY_PATH; audio-nix's wrapper only ships Bitwig's own deps.
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
      # The inner wrapper uses `--suffix LD_LIBRARY_PATH`, so this survives
      # bubblewrap. The .desktop launches `bitwig-studio` via PATH.
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
