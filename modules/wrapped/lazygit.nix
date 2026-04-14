{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      themeFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/lazygit/main/themes-mergable/mocha/blue.yml";
        sha256 = "1a8ccxzcka396bzslllqk81n1kwkggk5hi4pl3rv865v1qhzc7k5";
      };
    in
    {
      packages.lazygit = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.lazygit;
        flags = {
          "--use-config-file" = toString themeFile;
        };
      };
    };

}
