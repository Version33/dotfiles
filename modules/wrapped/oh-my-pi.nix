{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      version = "17.2.10";

      # Prebuilt bun single-file executable. It embeds its JS payload in a
      # trailer at the end of the file and reads itself via /proc/self/exe, so
      # the binary must stay byte-identical (patchelf would corrupt it).
      omp-bin = pkgs.fetchurl {
        url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-linux-x64";
        hash = "sha256-T+VksjSCzWJ2caJBeEJJjJey9ytfijpO+4CU5iPfejM=";
      };

      omp-unwrapped = pkgs.runCommandLocal "omp-unwrapped-${version}" { } ''
        install -Dm755 ${omp-bin} $out/bin/omp
      '';

      # Run the unpatched binary inside an FHS env so /lib64/ld-linux is present.
      # libstdc++ is also needed by the pi-natives .node addon it extracts at
      # runtime.
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

      # The startup "new version available" nag is gated on the `startup.checkUpdate`
      # *setting* (default true) — main.ts:113 short-circuits checkForNewVersion()
      # and main.ts:506 the notification. It is not an env var, so the old
      # PI_SKIP_VERSION_CHECK / PI_TELEMETRY entries this module used to set were
      # dead: neither string appears anywhere in the v17 source tree.
      #
      # Updating here is declarative, and `omp update` could not rewrite a
      # read-only store path anyway, so the check is pure noise.
      #
      # PI_CONFIG_FILES layers read-only YAML overlays on top of the user's own
      # ~/.omp/agent/config.yml without owning it. Merge precedence is
      # runtime override -> config overlay -> project -> global -> default
      # (settings.ts:967), so this wins while `omp config set` keeps working for
      # every other key. Note the overlay loader is strict — it throws if the
      # file is missing or is not a YAML mapping.
      settingsOverlay = (pkgs.formats.yaml { }).generate "omp-nix-settings.yml" {
        startup.checkUpdate = false;
      };
    in
    {
      packages.oh-my-pi = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = omp;
        # envDefault, so setting PI_CONFIG_FILES yourself replaces this rather
        # than appending — add the path back if you take that over.
        envDefault = {
          PI_CONFIG_FILES = "${settingsOverlay}";
        };
      };
    };
}
