{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      # audio-nix stable lags upstream (6.0.6) and 6-latest is a time-bombed
      # beta; bump the source and re-wrap. Drop once audio-nix catches up.
      version = "6.0.11";
      unwrapped = inputs.audio-nix.packages.${system}.bitwig-studio6-0-unwrapped.overrideAttrs (old: {
        inherit version;
        src = pkgs.fetchurl {
          url = "https://downloads-secure.bitwig.com/${version}/bitwig-studio-${version}.deb?source_url=/dl/Bitwig%20Studio/${version}/installer_linux/";
          sha256 = "sha256-rnr/Z8y6klKrU2gT5/XT+sRryl/HZZZ04n565L0HPEw=";
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
