{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      settings = {
        font_family = "JetBrainsMono Nerd Font Mono";
        font_size = 12;

        enable_audio_bell = "no";
        cursor_text_color = "background";
        cursor_trail = 3;

        copy_on_select = "clipboard";
        allow_remote_control = "socket-only";
        listen_on = "unix:@mykitty";
        shell_integration = "enabled";
      };

      kittyKeyValueFormat = pkgs.formats.keyValue {
        listsAsDuplicateKeys = true;
        mkKeyValue = lib.generators.mkKeyValueDefault { } " ";
      };

      baseConfig = kittyKeyValueFormat.generate "kitty.conf" settings;

      configFile = pkgs.writeText "kitty.conf" ''
        ${builtins.readFile baseConfig}
        include ${
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/kitty/43098316202b84d6a71f71aaf8360f102f4d3f1a/themes/mocha.conf";
            sha256 = "1kgr1vi9n083w3xw8ndwqkh03w74ma0ajg5m6pzy9fj2smycjski";
          }
        }
      '';
    in
    {
      packages.kitty = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.kitty;
        flags = {
          "-c" = toString configFile;
        };
      };
    };

}
