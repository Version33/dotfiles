{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, theme, ... }:
    let
      c = theme.colors.withHashtag;

      # `theme.custom` recolours tokens but the chrome still comes from a
      # built-in `theme.name`; pick the closest family, [ dark light ].
      builtin = {
        catppuccin = [
          "catppuccin"
          "catppuccin-latte"
        ];
        gruvbox = [
          "gruvbox"
          "gruvbox-light"
        ];
        tokyo-night = [
          "tokyo-night"
          "tokyo-night-day"
        ];
        dracula = [
          "dracula"
          "dracula"
        ];
        nord = [
          "nord"
          "nord"
        ];
        "one-" = [
          "one-dark"
          "one-light"
        ];
        solarized = [
          "solarized"
          "solarized-light"
        ];
        kanagawa = [
          "kanagawa"
          "kanagawa-lotus"
        ];
        rose-pine = [
          "rose-pine"
          "rose-pine-dawn"
        ];
      };
      family = lib.findFirst (p: lib.hasPrefix p theme.scheme) "catppuccin" (lib.attrNames builtin);
      name = lib.elemAt builtin.${family} (if theme.dark then 0 else 1);

      configFile = pkgs.writeText "herdr-config.toml" ''
        [theme]
        name = "${name}"

        [theme.custom]
        accent = "#${theme.accent}"
        panel_bg = "${c.base00}"
        sidebar_bg = "${c.base01}"
        active_row_bg = "${c.base02}"
        selection_bg = "${c.base02}"
        surface0 = "${c.base01}"
        surface1 = "${c.base02}"
        surface_dim = "${c.base00}"
        overlay0 = "${c.base02}"
        overlay1 = "${c.base03}"
        text = "${c.base05}"
        subtext0 = "${c.base04}"
        mauve = "${c.base0E}"
        green = "${c.base0B}"
        yellow = "${c.base0A}"
        red = "${c.base08}"
        blue = "${c.base0D}"
        teal = "${c.base0C}"
        peach = "${c.base09}"
      '';
    in
    {
      packages.herdr = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.herdr;
        envDefault = {
          HERDR_CONFIG_PATH = toString configFile;
        };
      };
    };
}
