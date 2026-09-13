{ inputs, ... }:
{
  perSystem =
    { pkgs, theme, ... }:
    {
      packages.lazygit = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.lazygit;
        flags = {
          "--use-config-file" = toString (theme.colors inputs.tinted-lazygit);
        };
      };
    };

}
