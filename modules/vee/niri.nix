{ self, ... }:
{

  flake.modules.nixos.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };

      environment.systemPackages = [ pkgs.catppuccin-cursors.mochaDark ];

      # XWayland apps (e.g. Steam) read XCURSOR_* env vars rather than the
      # niri compositor cursor setting, so we need both.
      # NixOS sets XCURSOR_PATH to only user dirs, overriding libXcursor's
      # compiled-in default. Prepend the nix store cursor path so XWayland
      # can find custom themes.
      environment.sessionVariables = {
        XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
        XCURSOR_SIZE = "24";
        XCURSOR_PATH = lib.mkForce "${pkgs.catppuccin-cursors.mochaDark}/share/icons:~/.icons:~/.local/share/icons";
      };

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd niri-session";
            user = "greeter";
          };
        };
      };
    };

}
