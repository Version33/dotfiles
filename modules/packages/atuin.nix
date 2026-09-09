{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # Config dir must be a dir; history stays in the writable XDG data dir.
      configDir = pkgs.runCommandLocal "atuin-config" { } ''
        mkdir -p $out
        cp ${configFile} $out/config.toml
      '';
      configFile = pkgs.writeText "atuin-config.toml" ''
        ## No sync account configured — stay local.
        auto_sync = false
        update_check = false

        ## UI
        style = "compact"
        inline_height = 20
        show_preview = true

        ## Up-arrow = this session; Ctrl-R searches everything.
        filter_mode_shell_up_key_binding = "session"

        ## <Enter> puts the command on the prompt instead of running it.
        enter_accept = false
      '';
    in
    {
      packages.atuin =
        (inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.atuin;
          # envDefault: an explicit ATUIN_CONFIG_DIR still wins.
          envDefault = {
            ATUIN_CONFIG_DIR = "${configDir}";
          };
        })
        // {
          inherit configDir configFile;
        };
    };
}
