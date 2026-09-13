{ inputs, ... }:
{
  perSystem =
    { pkgs, theme, ... }:
    let
      c = theme.colors.withHashtag;
      # https://docs.atuin.sh/latest/guide/theming/
      themeFile = pkgs.writeText "${theme.scheme}.toml" ''
        [theme]
        name = "${theme.scheme}"

        [colors]
        Base = "${c.base05}"
        Title = "#${theme.accent}"
        Annotation = "${c.base03}"
        Guidance = "${c.base0D}"
        Important = "${c.base0E}"
        AlertInfo = "${c.base0B}"
        AlertWarn = "${c.base0A}"
        AlertError = "${c.base08}"
      '';
      themesDir = pkgs.linkFarm "atuin-themes" { "${theme.scheme}.toml" = themeFile; };
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

        ## <Enter> puts the command on the prompt instead of running it.
        enter_accept = false

        [theme]
        name = "${theme.scheme}"
      '';
    in
    {
      packages.atuin =
        (inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.atuin;
          # envDefault: explicit ATUIN_CONFIG_DIR/ATUIN_THEME_DIR still win.
          envDefault = {
            ATUIN_CONFIG_DIR = "${configDir}";
            ATUIN_THEME_DIR = "${themesDir}";
          };
        })
        // {
          inherit
            configDir
            configFile
            themesDir
            themeFile
            ;
        };
    };
}
