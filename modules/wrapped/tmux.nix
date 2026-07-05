# TODO: Remove - replaced by herdr
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      tmux2k = pkgs.fetchFromGitHub {
        owner = "2KAbhishek";
        repo = "tmux2k";
        rev = "e6355f9ca0ed2cbaabbdef13d95af86e4d941671";
        hash = "sha256-fZVZwC2DvfCx/X7mlUPv9mCimc5aoUwH3CFCWiM61XU=";
      };

      configFile = pkgs.writeText "tmux.conf" ''
        set -g @tmux2k-theme 'catppuccin'

        run-shell ${tmux2k}/2k.tmux
      '';
    in
    {
      packages.tmux = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.tmux;
        flags = {
          "-f" = toString configFile;
        };
      };
    };
}
