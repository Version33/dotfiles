{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, theme, ... }:
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
          theme.colors {
            template = builtins.readFile "${inputs.tinted-terminal}/templates/kitty-${theme.system}.mustache";
            extension = ".conf";
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
