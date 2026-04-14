{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      themeFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/lazygit/main/themes/mocha/blue.yml";
        sha256 = "1kzq15bsd384bws3z2k1x3r742gwkiva0680a1ylx7glw02jizvf";
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
