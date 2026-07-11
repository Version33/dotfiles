{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      themeFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/btop/cf50077d8d50e009b5f58aad4bb32603db895f17/themes/catppuccin_mocha.theme";
        sha256 = "0i263xwkkv8zgr71w13dnq6cv10bkiya7b06yqgjqa6skfmnjx2c";
      };
      themesDir = pkgs.runCommand "btop-catppuccin-themes" { } ''
        mkdir -p $out
        ln -s ${themeFile} $out/catppuccin_mocha.theme
      '';
      configFile = pkgs.writeText "btop.conf" ''
        color_theme = "catppuccin_mocha"
      '';
    in
    {
      packages.btop = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.btop-rocm;
        flags = {
          "--themes-dir" = toString themesDir;
          "-c" = toString configFile;
        };
      };
    };
}
