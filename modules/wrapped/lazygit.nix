{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      themeFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/lazygit/9e36639c9a5f241ec05c70ecfcf87032be45ea3f/themes-mergable/mocha/blue.yml";
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
