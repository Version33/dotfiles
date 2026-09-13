{
  flake.modules.nixos.users-desktop =
    {
      self,
      pkgs,
      lib,
      theme,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      gtkTheme = if theme.dark then "adw-gtk3-dark" else "adw-gtk3";
    in
    {
      programs.niri = {
        enable = true;
        package = self.packages.${system}.niri;
      };

      # Runs under systemd so `nixos-rebuild switch` restarts it with niri;
      # a leftover daemon from an older generation is unreachable via IPC,
      # leaving Mod+S dead until relogin.
      systemd.user.services.noctalia = {
        description = "Noctalia desktop shell";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        # systemd units get a minimal PATH (unlike spawn-at-startup); Noctalia
        # shells out at runtime (magick, etc.) and silently breaks without this.
        path = [ "/run/current-system/sw" ];
        serviceConfig = {
          # Quickshell never GCs $XDG_RUNTIME_DIR/quickshell/by-id/*; a
          # crash-loop once filled the tmpfs and broke IPC (ENOSPC). Prune
          # dead instances (matched via by-pid/<pid> -> /proc) before start.
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

      environment = {
        systemPackages = with pkgs; [
          theme.cursor.package
          adw-gtk3
        ];

        sessionVariables = {
          XCURSOR_THEME = theme.cursor.name;
          XCURSOR_SIZE = "24";
          XCURSOR_PATH = lib.mkForce "${theme.cursor.package}/share/icons:~/.icons:~/.local/share/icons";
          GTK_THEME = gtkTheme;
          NIXOS_OZONE_WL = "1";
          BAT_THEME = "base16";
        };

        # GTK only reads settings.ini from $XDG_CONFIG_DIRS (starts at
        # /etc/xdg, not bare /etc), hence etc/xdg here. gtk.css has no
        # system-wide equivalent — only read from per-user $XDG_CONFIG_HOME.
        etc = {
          "xdg/gtk-3.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=${gtkTheme}
            gtk-application-prefer-dark-theme=${if theme.dark then "1" else "0"}
          '';
          "xdg/gtk-4.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=${gtkTheme}
            gtk-application-prefer-dark-theme=${if theme.dark then "1" else "0"}
          '';
        };
      };

      # Also what tuigreet (greetd, below) renders with.
      console.colors = theme.ansi;

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
