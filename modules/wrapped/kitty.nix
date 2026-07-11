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
        allow_remote_control = "yes";
        listen_on = "unix:@mykitty";
        shell_integration = "enabled";

        map = [
          "alt+1 goto_tab 1"
          "alt+2 goto_tab 2"
          "alt+3 goto_tab 3"
          "alt+4 goto_tab 4"
          "alt+5 goto_tab 5"
          "alt+6 goto_tab 6"
          "alt+7 goto_tab 7"
          "alt+8 goto_tab 8"
          "alt+9 goto_tab 9"
          "ctrl+shift+w close_tab"
          "ctrl+t new_tab_with_cwd"
          "ctrl+shift+t new_tab"
        ];
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
