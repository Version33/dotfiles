{ ... }:
let
  mkYazi =
    pkgs:
    pkgs.yazi.override {
      plugins = {
        "wl-clipboard" = pkgs.yaziPlugins.wl-clipboard;
      };
      extraPackages = [ pkgs.wl-clipboard ];
      settings.keymap = {
        manager.keymap = [
          {
            on = "<C-y>";
            run = "plugin wl-clipboard";
            desc = "Copy to clipboard";
          }
        ];
      };
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.yazi = mkYazi pkgs;
    };

  flake.modules.nixos.wrapped-yazi =
    { pkgs, ... }:
    {
      environment.systemPackages = [ (mkYazi pkgs) ];
    };
}
