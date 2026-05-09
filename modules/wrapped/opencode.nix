{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      tuiConfig = pkgs.writeText "tui.json" (builtins.toJSON {
        theme = "catppuccin";
      });
    in
    {
      packages.opencode = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.opencode;
        envDefault.OPENCODE_TUI_CONFIG = toString tuiConfig;
      };
    };
}
