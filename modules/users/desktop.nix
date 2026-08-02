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
        package = self.packages.${system}.niri;
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
        # spawn-at-startup inherited the full session PATH; systemd units get
        # only the minimal default. Noctalia shells out at runtime (sh, magick,
        # etc.) — without this the wallpaper pipeline silently dies.
        path = [ "/run/current-system/sw" ];
        serviceConfig = {
          # Quickshell never GCs $XDG_RUNTIME_DIR/quickshell/by-id/* — every
          # restart leaks a run dir, and a crash-looping instance leaks its
          # log.log unbounded (a broken-PATH loop once filled the 6G tmpfs;
          # the next instance then got ENOSPC on instance.lock, so `ipc call`
          # found no instance and Mod+S went dead). Prune dead instances
          # before each start. Live ones are identified via by-pid/<pid>
          # symlinks against /proc; quickshell's comm is ".quickshell-wra*".
          ExecStartPre = pkgs.writeShellScript "quickshell-runtime-gc" ''
            base="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/quickshell"
            [ -d "$base" ] || exit 0
            for link in "$base"/by-pid/*; do
              [ -L "$link" ] || continue
              pid="''${link##*/}"
              target="$(readlink "$link")"
              if ! grep -q quickshell "/proc/$pid/comm" 2>/dev/null; then
                case "$target" in
                  "$base"/by-id/*) rm -rf "$target" ;;
                esac
                rm -f "$link"
              fi
            done
            for dir in "$base"/by-id/*; do
              [ -d "$dir" ] || continue
              live=0
              for link in "$base"/by-pid/*; do
                [ "$(readlink "$link" 2>/dev/null)" = "$dir" ] && live=1 && break
              done
              [ "$live" -eq 1 ] || rm -rf "$dir"
            done
            find "$base"/by-path "$base"/by-shell -xtype l -delete 2>/dev/null
            exit 0
          '';
          ExecStart = lib.getExe self.packages.${system}.noctalia;
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
