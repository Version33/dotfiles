_: {
  perSystem =
    { lib, pkgs, ... }:
    let
      version = "0.7.0";

      # Prebuilt bun single-file executable: the JS payload is appended to the
      # ELF image, and `patchelf --set-rpath` shifts it enough to segfault the
      # binary. Keep it byte-identical and invoke the loader explicitly instead.
      # `--library-path` is a loader argument, not an env var, so it never leaks
      # into the browser that `auth login` spawns via xdg-open.
      proton-drive-bin = pkgs.fetchurl {
        url = "https://proton.me/download/drive/cli/${version}/linux-x64/proton-drive";
        hash = "sha256-Tjx0p6JdoA16DKnuIjqbewsjjaNXq2/P7gSlwxPd9NE=";
      };

      # DT_NEEDED is glibc only; libsecret (Secret Service session storage) and
      # glib are dlopened at runtime, so they have to be on the search path.
      libPath = lib.makeLibraryPath [
        pkgs.libsecret
        pkgs.glib
      ];
    in
    {
      packages.proton-drive =
        pkgs.runCommandLocal "proton-drive-${version}"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
            meta = {
              description = "Command-line interface for Proton Drive";
              homepage = "https://proton.me/support/drive-cli";
              mainProgram = "proton-drive";
              platforms = [ "x86_64-linux" ];
            };
          }
          ''
            install -Dm555 ${proton-drive-bin} $out/libexec/proton-drive
            makeWrapper ${pkgs.stdenv.cc.bintools.dynamicLinker} $out/bin/proton-drive \
              --add-flags "--library-path ${libPath} $out/libexec/proton-drive"
          '';
    };
}
