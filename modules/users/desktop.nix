{
  flake.modules.nixos.users-desktop =
    { self, pkgs, lib, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      programs.niri = {
        enable = true;
        package = self.packages.${system}.myNiri;
      };

      environment = {
        systemPackages = with pkgs; [
          catppuccin-cursors.mochaDark
          adw-gtk3
        ];

        sessionVariables = {
          XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
          XCURSOR_SIZE = "24";
          XCURSOR_PATH = lib.mkForce "${pkgs.catppuccin-cursors.mochaDark}/share/icons:~/.icons:~/.local/share/icons";
          GTK_THEME = "adw-gtk3-dark";
        };

        etc = {
          "gtk-3.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=adw-gtk3-dark
            gtk-application-prefer-dark-theme=1
          '';
          "gtk-3.0/gtk.css".text = ''
            headerbar {
              background-color: #1e1e2e;
              color: #cdd6f4;
            }
          '';
          "gtk-4.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=adw-gtk3-dark
            gtk-application-prefer-dark-theme=1
          '';
          "gtk-4.0/gtk.css".text = ''
            headerbar {
              background-color: #1e1e2e;
              color: #cdd6f4;
            }
          '';
        };
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
