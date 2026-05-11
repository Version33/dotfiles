{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      tuiConfig = pkgs.writeText "tui.json" (
        builtins.toJSON {
          theme = "catppuccin";
        }
      );
      opencodeConfig = pkgs.writeText "opencode.json" (
        builtins.toJSON {
          mcp = {
            context7 = {
              type = "remote";
              url = "https://mcp.context7.com/mcp";
            };
            gh_grep = {
              type = "remote";
              url = "https://mcp.grep.app";
            };
            sentry = {
              type = "remote";
              url = "https://mcp.sentry.dev/mcp";
              oauth = { };
            };
          };
        }
      );
    in
    {
      packages.opencode = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.opencode;
        envDefault = {
          OPENCODE_TUI_CONFIG = toString tuiConfig;
          OPENCODE_CONFIG = toString opencodeConfig;
        };
      };
    };
}
