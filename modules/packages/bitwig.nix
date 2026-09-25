{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      # audio-nix's `bitwig-studio6-1` = bubblewrap-wrapped 6.1.x.
      bitwig = inputs.audio-nix.packages.${system}.bitwig-studio6-1;

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
