{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      themeFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/lazygit/1a4b26cbc2b5be05cc5494d0d7f764120a2cf86d/themes-mergable/mocha/blue.yml";
        sha256 = "0sci00g3hp8ckvd0nl2my032drphcmkpg4smrs0y411m0dcln9rx";
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
