{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      # xwayland-satellite's X11 -> logical -> X11 popup coordinate
      # round-trip truncates twice at fractional output scales; the
      # resulting off-by-one ConfigureNotify makes strict clients (JUCE
      # popup menus in wine/yabridge plugins, e.g. ShaperBox 3) dismiss
      # instantly. The patch remembers the exact pixel values a popup
      # requested and reuses them when the compositor echoes the request
      # back unchanged. Verified against upstream's full test suite.
      # Drop once merged upstream (see the issue draft in ~/Downloads).
      xwayland-satellite-patched = pkgs.xwayland-satellite.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./xwayland-satellite-popup-exact.patch ];
      });
    in
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          environment = {
            XCURSOR_PATH = "${pkgs.catppuccin-cursors.mochaDark}/share/icons";
          };

          xwayland-satellite.path = lib.getExe xwayland-satellite-patched;

          # Wait for Tidal's window before starting GoofCord so Tidal
          # always ends up on the left.
          spawn-at-startup = [
            (toString (
              pkgs.writeShellScript "startup-apps" ''
                ${lib.getExe pkgs.tidal-hifi} &
                for _ in $(seq 100); do
                  ${lib.getExe' pkgs.niri "niri"} msg windows | grep -q '"tidal-hifi"' && break
                  sleep 0.2
                done
                exec ${lib.getExe self'.packages.goofcord}
              ''
            ))
          ];

          cursor = {
            xcursor-theme = "catppuccin-mocha-dark-cursors";
            xcursor-size = 24;
          };

          input = {
            keyboard.xkb.layout = "us";
            mouse = {
              accel-profile = "flat";
            };
          };

          # Disable the top-left hot corner (overview trigger).
          gestures.hot-corners.off = _: { };

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

          layout = {
            gaps = 10;
            focus-ring = {
              width = 4;
              active-color = "#cba6f7";
              inactive-color = "#45475a";
            };
          };

          # Steam notification toasts are XWayland windows that bypass
          # D-Bus. Float them, anchor to bottom-right, never focus them.
          window-rules = [
            {
              geometry-corner-radius = 8;
              clip-to-geometry = true;
            }
            {
              matches = [
                {
                  app-id = "steam";
                  title = "notificationtoasts";
                }
              ];
              open-floating = true;
              open-focused = false;
              default-floating-position = _: {
                props = {
                  x = 0;
                  y = 0;
                  relative-to = "bottom-right";
                };
              };
            }
            {
              matches = [
                { app-id = "tidal-hifi"; }
                { app-id = "goofcord"; }
              ];
              open-on-output = "DP-2";
            }
          ];

          binds = {
            # Apps
            "Mod+Return".spawn-sh = lib.getExe self'.packages.kitty;
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";

            # Window management
            "Mod+Q".close-window = _: { };
            "Mod+F".fullscreen-window = _: { };
            "Mod+V".toggle-window-floating = _: { };
            "Mod+C".center-column = _: { };

            # Focus movement
            "Mod+Left".focus-column-or-monitor-left = _: { };
            "Mod+Right".focus-column-or-monitor-right = _: { };
            "Mod+Up".focus-window-or-workspace-up = _: { };
            "Mod+Down".focus-window-or-workspace-down = _: { };
            "Mod+H".focus-column-or-monitor-left = _: { };
            "Mod+L".focus-column-or-monitor-right = _: { };
            "Mod+K".focus-window-or-workspace-up = _: { };
            "Mod+J".focus-window-or-workspace-down = _: { };

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
            "Mod+Ctrl+K".focus-workspace-up = _: { };
            "Mod+Ctrl+J".focus-workspace-down = _: { };
            "Mod+Ctrl+Up".focus-workspace-up = _: { };
            "Mod+Ctrl+Down".focus-workspace-down = _: { };
            "Mod+Ctrl+Shift+K".move-column-to-workspace-up = _: { };
            "Mod+Ctrl+Shift+J".move-column-to-workspace-down = _: { };
            "Mod+Ctrl+Shift+Up".move-column-to-workspace-up = _: { };
            "Mod+Ctrl+Shift+Down".move-column-to-workspace-down = _: { };

            # Monitors
            "Mod+Ctrl+H".focus-monitor-left = _: { };
            "Mod+Ctrl+L".focus-monitor-right = _: { };
            "Mod+Ctrl+Left".focus-monitor-left = _: { };
            "Mod+Ctrl+Right".focus-monitor-right = _: { };
            "Mod+Ctrl+Shift+H".move-column-to-monitor-left = _: { };
            "Mod+Ctrl+Shift+L".move-column-to-monitor-right = _: { };
            "Mod+Ctrl+Shift+Left".move-column-to-monitor-left = _: { };
            "Mod+Ctrl+Shift+Right".move-column-to-monitor-right = _: { };

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
