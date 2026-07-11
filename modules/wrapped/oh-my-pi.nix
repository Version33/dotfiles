{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      version = "16.3.12";

      # Prebuilt bun single-file executable. It embeds its JS payload in a
      # trailer at the end of the file and reads itself via /proc/self/exe, so
      # the binary must stay byte-identical (patchelf would corrupt it).
      omp-bin = pkgs.fetchurl {
        url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-linux-x64";
        hash = "sha256-x8sBV2xpbZa5bCHWkegpRRGb87u3MW4+ifxbF+IH27c=";
      };

      omp-unwrapped = pkgs.runCommandLocal "omp-unwrapped-${version}" { } ''
        install -Dm755 ${omp-bin} $out/bin/omp
      '';

      # Run the unpatched binary inside an FHS env so /lib64/ld-linux is present.
      omp = pkgs.buildFHSEnv {
        name = "omp";
        targetPkgs = pkgs: [ pkgs.stdenv.cc.cc.lib ];
        runScript = "${omp-unwrapped}/bin/omp";
        meta = {
          description = "AI coding agent for the terminal (fork of Pi)";
          homepage = "https://github.com/can1357/oh-my-pi";
          mainProgram = "omp";
          platforms = [ "x86_64-linux" ];
        };
      };
    in
    {
      packages.oh-my-pi = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = omp;
        envDefault = {
          PI_SKIP_VERSION_CHECK = "1";
          PI_TELEMETRY = "0";
        };
      };
    };
}
