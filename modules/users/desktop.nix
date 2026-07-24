{
  flake.modules.nixos.users-desktop =
    {
      self,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      programs.niri = {
        enable = true;
        package = self.packages.${system}.myNiri;
      };

      # Run noctalia under systemd so `nixos-rebuild switch` restarts it in
      # lockstep with the niri.service config reload. Quickshell IPC targets
      # instances by config store path; a daemon left over from an older
      # generation is unreachable from the rebuilt Mod+S bind (launcher dead
      # until relogin).
      systemd.user.services.noctalia = {
        description = "Noctalia desktop shell";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = lib.getExe self.packages.${system}.myNoctalia;
          Restart = "on-failure";
          RestartSec = 1;
        };
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
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
          NIXOS_OZONE_WL = "1";
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
