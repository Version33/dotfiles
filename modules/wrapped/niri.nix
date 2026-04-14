{ self, inputs, ... }:
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
      environment.sessionVariables = {
        XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
        XCURSOR_SIZE = "24";
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

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        v2-settings = true;
        settings = {
          spawn-at-startup = [
            (lib.getExe self'.packages.myNoctalia)
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          cursor = {
            xcursor-theme = "catppuccin-mocha-dark-cursors";
            xcursor-size = 24;
          };

          input = {
            keyboard.xkb.layout = "us,ua";
            mouse = {
              accel-profile = "flat";
            };
          };

          outputs = {
            # DP-2 is on the left, DP-1 is on the right
            # Logical size at scale 1.25: 3840/1.25 = 3072px wide each
            "DP-2" = {
              mode = "3840x2160@239.987";
              scale = 1.25;
              position = _: {
                props = {
                  x = 0;
                  y = 0;
                };
              };
              variable-refresh-rate = _: {
                props = {
                  on-demand = true;
                };
              };
            };
            "DP-1" = {
              mode = "3840x2160@239.987";
              scale = 1.25;
              position = _: {
                props = {
                  x = 3072;
                  y = 0;
                };
              };
              variable-refresh-rate = _: {
                props = {
                  on-demand = true;
                };
              };
            };
          };

          layout.gaps = 5;

          binds = {
            # Apps
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";

            # Window management
            "Mod+Q".close-window = _: { };
            "Mod+F".fullscreen-window = _: { };
            "Mod+V".toggle-window-floating = _: { };
            "Mod+C".center-column = _: { };

            # Focus movement
            "Mod+Left".focus-column-left = _: { };
            "Mod+Right".focus-column-right = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Down".focus-window-down = _: { };
            "Mod+H".focus-column-left = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+J".focus-window-down = _: { };

            # Move windows
            "Mod+Shift+Left".move-column-left = _: { };
            "Mod+Shift+Right".move-column-right = _: { };
            "Mod+Shift+Up".move-window-up = _: { };
            "Mod+Shift+Down".move-window-down = _: { };
            "Mod+Shift+H".move-column-left = _: { };
            "Mod+Shift+L".move-column-right = _: { };
            "Mod+Shift+K".move-window-up = _: { };
            "Mod+Shift+J".move-window-down = _: { };

            # Column sizing
            "Mod+R".switch-preset-column-width = _: { };
            "Mod+Shift+R".reset-window-height = _: { };
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            # Workspaces
            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+Shift+1".move-column-to-workspace = 1;
            "Mod+Shift+2".move-column-to-workspace = 2;
            "Mod+Shift+3".move-column-to-workspace = 3;
            "Mod+Shift+4".move-column-to-workspace = 4;
            "Mod+Shift+5".move-column-to-workspace = 5;
            "Mod+Page_Down".focus-workspace-down = _: { };
            "Mod+Page_Up".focus-workspace-up = _: { };
            "Mod+Shift+Page_Down".move-column-to-workspace-down = _: { };
            "Mod+Shift+Page_Up".move-column-to-workspace-up = _: { };

            # Scroll to switch workspaces
            "Mod+WheelScrollDown"."focus-workspace-down" = _: { };
            "Mod+WheelScrollUp"."focus-workspace-up" = _: { };

            # Screenshots
            "Print".screenshot = _: { };
            "Ctrl+Print".screenshot-screen = _: { };
            "Alt+Print".screenshot-window = _: { };

            # Media keys
            "XF86AudioRaiseVolume".spawn-sh = "${lib.getExe pkgs.pamixer} --increase 5";
            "XF86AudioLowerVolume".spawn-sh = "${lib.getExe pkgs.pamixer} --decrease 5";
            "XF86AudioMute".spawn-sh = "${lib.getExe pkgs.pamixer} --toggle-mute";
            "XF86AudioMicMute".spawn-sh = "${lib.getExe pkgs.pamixer} --default-source --toggle-mute";
            "XF86AudioPlay".spawn-sh = "${lib.getExe pkgs.playerctl} play-pause";
            "XF86AudioStop".spawn-sh = "${lib.getExe pkgs.playerctl} stop";
            "XF86AudioNext".spawn-sh = "${lib.getExe pkgs.playerctl} next";
            "XF86AudioPrev".spawn-sh = "${lib.getExe pkgs.playerctl} previous";

            # Misc
            "Mod+Shift+E".quit = _: { };
            "Mod+Shift+Slash".show-hotkey-overlay = _: { };
            "Mod+Escape".toggle-keyboard-shortcuts-inhibit = _: { };
          };
        };
      };
    };
}
