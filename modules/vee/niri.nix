{ self, ... }:
{

  flake.modules.nixos.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };

      environment.systemPackages = with pkgs; [
        catppuccin-cursors.mochaDark
        adw-gtk3
      ];

      # XWayland apps (e.g. Steam) read XCURSOR_* env vars rather than the
      # niri compositor cursor setting, so we need both.
      # NixOS sets XCURSOR_PATH to only user dirs, overriding libXcursor's
      # compiled-in default. Prepend the nix store cursor path so XWayland
      # can find custom themes.
      environment.sessionVariables = {
        XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
        XCURSOR_SIZE = "24";
        XCURSOR_PATH = lib.mkForce "${pkgs.catppuccin-cursors.mochaDark}/share/icons:~/.icons:~/.local/share/icons";
        GTK_THEME = "adw-gtk3-dark";
      };

      # Force dark theme preference so Electron/Wayland apps use a dark
      # title bar instead of white. Also override headerbar colors for
      # XWayland apps to Catppuccin Mocha base (#1e1e2e).
      environment.etc = {
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
