{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      themeFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/lazygit/798ad2e75a11766e9ba50e76e59aea6a81eb4866/themes-mergable/mocha/blue.yml";
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
