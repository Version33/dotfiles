{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # Config dir must be a dir; the page cache stays in the writable
      # $TEALDEER_CACHE_DIR, so auto_update below can refresh it.
      configDir = pkgs.runCommandLocal "tealdeer-config" { } ''
        mkdir -p $out
        cp ${configFile} $out/config.toml
      '';
      configFile = pkgs.writeText "tealdeer-config.toml" ''
        [display]
        compact = false
        use_pager = false

        [updates]
        # Refresh the page cache on staleness instead of manual `tldr -u`.
        auto_update = true
        auto_update_interval_hours = 720
      '';
    in
    {
      packages.tealdeer =
        (inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.tealdeer;
          # envDefault: an explicit TEALDEER_CONFIG_DIR still wins.
          envDefault = {
            TEALDEER_CONFIG_DIR = "${configDir}";
          };
        })
        // {
          inherit configDir configFile;
        };
    };
}
