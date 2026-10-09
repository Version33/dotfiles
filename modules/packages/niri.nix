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
      # xwayland-satellite's X11->logical->X11 popup round-trip drops a pixel
      # at fractional scale, making strict clients (JUCE popups in
      # wine/yabridge, e.g. ShaperBox 3) dismiss instantly. Drop once merged
      # upstream (draft issue in ~/Downloads).
      xwayland-satellite-patched = pkgs.xwayland-satellite.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./xwayland-satellite-popup-exact.patch ];
      });

      # Mod+LMB drag on a fullscreen window only unfullscreens it (upstream
      # design); refuse the move instead. Resize is already refused upstream.
      niri-patched = pkgs.niri.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./niri-no-fullscreen-move.patch ];
      });
    in
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        package = niri-patched;
        settings = {
          environment = {
            XCURSOR_PATH = "${pkgs.catppuccin-cursors.mochaDark}/share/icons";
          };

          xwayland-satellite.path = lib.getExe xwayland-satellite-patched;

          # Wait for Tidal's window before GoofCord so Tidal ends up on the left.
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

          # Prefer no client side decorations.
          prefer-no-csd = _: { };

          outputs = {
            # DP-2 left, DP-1 right; at scale 1.25 each output is 3072px logical-wide.
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

          # Steam toasts are XWayland windows that bypass D-Bus notifications.
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

          binds =
            let
              dms = args: "${lib.getExe self'.packages.dms-shell} ipc call ${args}";
              # Every bind carries a hotkey-overlay-title: the DMS cheatsheet
              # shows the raw action name otherwise (and niri's overlay would
              # show the nix store path for spawns). `hidden` keeps a bind out
              # of the cheatsheet.
              bind = title: action: _: {
                props.hotkey-overlay-title = title;
                content = action;
              };
              act = title: name: bind title { ${name} = _: { }; };
              app = title: cmd: bind title { spawn-sh = cmd; };
              hidden = app null;
            in
            {
              # Apps
              "Mod+Return" = app "Terminal" (lib.getExe self'.packages.kitty);

              # DMS shell
              "Mod+S" = app "App Launcher" (dms "spotlight toggle");
              "Mod+X" = app "Power Menu" (dms "powermenu toggle");
              "Mod+N" = app "Notifications" (dms "notifications toggle");
              "Mod+I" = app "Control Center" (dms "control-center toggle");
              "Mod+Shift+V" = app "Clipboard History" (dms "clipboard toggle");
              "Mod+Comma" = app "Settings" (dms "settings open");
              "Mod+Alt+L" = app "Lock Screen" (dms "lock lock");

              # Window management
              "Mod+Q" = act "Close Window" "close-window";
              "Mod+F" = act "Toggle Fullscreen" "fullscreen-window";
              "Mod+V" = act "Toggle Floating" "toggle-window-floating";
              "Mod+C" = act "Center Column" "center-column";

              # Focus movement
              "Mod+Left" = act "Focus Left" "focus-column-or-monitor-left";
              "Mod+Right" = act "Focus Right" "focus-column-or-monitor-right";
              "Mod+Up" = act "Focus Up" "focus-window-or-workspace-up";
              "Mod+Down" = act "Focus Down" "focus-window-or-workspace-down";
              "Mod+H" = act "Focus Left" "focus-column-or-monitor-left";
              "Mod+L" = act "Focus Right" "focus-column-or-monitor-right";
              "Mod+K" = act "Focus Up" "focus-window-or-workspace-up";
              "Mod+J" = act "Focus Down" "focus-window-or-workspace-down";

              # Move windows
              "Mod+Shift+Left" = act "Move Column Left" "move-column-left";
              "Mod+Shift+Right" = act "Move Column Right" "move-column-right";
              "Mod+Shift+Up" = act "Move Window Up" "move-window-up";
              "Mod+Shift+Down" = act "Move Window Down" "move-window-down";
              "Mod+Shift+H" = act "Move Column Left" "move-column-left";
              "Mod+Shift+L" = act "Move Column Right" "move-column-right";
              "Mod+Shift+K" = act "Move Window Up" "move-window-up";
              "Mod+Shift+J" = act "Move Window Down" "move-window-down";

              # Column sizing
              "Mod+R" = act "Cycle Column Width" "switch-preset-column-width";
              "Mod+Shift+R" = act "Reset Window Height" "reset-window-height";
              "Mod+Minus" = bind "Shrink Column" { set-column-width = "-10%"; };
              "Mod+Equal" = bind "Grow Column" { set-column-width = "+10%"; };
              "Mod+Shift+Minus" = bind "Shrink Window Height" { set-window-height = "-10%"; };
              "Mod+Shift+Equal" = bind "Grow Window Height" { set-window-height = "+10%"; };

              # Workspaces
              "Mod+Ctrl+K" = act "Workspace Up" "focus-workspace-up";
              "Mod+Ctrl+J" = act "Workspace Down" "focus-workspace-down";
              "Mod+Ctrl+Up" = act "Workspace Up" "focus-workspace-up";
              "Mod+Ctrl+Down" = act "Workspace Down" "focus-workspace-down";
              "Mod+Ctrl+Shift+K" = act "Move Column to Workspace Up" "move-column-to-workspace-up";
              "Mod+Ctrl+Shift+J" = act "Move Column to Workspace Down" "move-column-to-workspace-down";
              "Mod+Ctrl+Shift+Up" = act "Move Column to Workspace Up" "move-column-to-workspace-up";
              "Mod+Ctrl+Shift+Down" = act "Move Column to Workspace Down" "move-column-to-workspace-down";

              # Monitors
              "Mod+Ctrl+H" = act "Focus Monitor Left" "focus-monitor-left";
              "Mod+Ctrl+L" = act "Focus Monitor Right" "focus-monitor-right";
              "Mod+Ctrl+Left" = act "Focus Monitor Left" "focus-monitor-left";
              "Mod+Ctrl+Right" = act "Focus Monitor Right" "focus-monitor-right";
              "Mod+Ctrl+Shift+H" = act "Move Column to Monitor Left" "move-column-to-monitor-left";
              "Mod+Ctrl+Shift+L" = act "Move Column to Monitor Right" "move-column-to-monitor-right";
              "Mod+Ctrl+Shift+Left" = act "Move Column to Monitor Left" "move-column-to-monitor-left";
              "Mod+Ctrl+Shift+Right" = act "Move Column to Monitor Right" "move-column-to-monitor-right";

              "Mod+1" = bind "Workspace 1" { focus-workspace = 1; };
              "Mod+2" = bind "Workspace 2" { focus-workspace = 2; };
              "Mod+3" = bind "Workspace 3" { focus-workspace = 3; };
              "Mod+4" = bind "Workspace 4" { focus-workspace = 4; };
              "Mod+5" = bind "Workspace 5" { focus-workspace = 5; };
              "Mod+Shift+1" = bind "Move Column to Workspace 1" { move-column-to-workspace = 1; };
              "Mod+Shift+2" = bind "Move Column to Workspace 2" { move-column-to-workspace = 2; };
              "Mod+Shift+3" = bind "Move Column to Workspace 3" { move-column-to-workspace = 3; };
              "Mod+Shift+4" = bind "Move Column to Workspace 4" { move-column-to-workspace = 4; };
              "Mod+Shift+5" = bind "Move Column to Workspace 5" { move-column-to-workspace = 5; };
              "Mod+Page_Down" = act "Workspace Down" "focus-workspace-down";
              "Mod+Page_Up" = act "Workspace Up" "focus-workspace-up";
              "Mod+Shift+Page_Down" = act "Move Column to Workspace Down" "move-column-to-workspace-down";
              "Mod+Shift+Page_Up" = act "Move Column to Workspace Up" "move-column-to-workspace-up";

              # Scroll to switch workspaces
              "Mod+WheelScrollDown" = act "Workspace Down" "focus-workspace-down";
              "Mod+WheelScrollUp" = act "Workspace Up" "focus-workspace-up";

              # Mod+Shift+S opens the capture menu; Print binds go through dms screenshot.
              "Mod+Shift+S" = app "Screenshot Menu" (lib.getExe self'.packages.screenshot-menu);
              "Print" = app "Screenshot (Region)" "${lib.getExe self'.packages.dms-shell} screenshot";
              "Ctrl+Print" = app "Screenshot (Full)" "${lib.getExe self'.packages.dms-shell} screenshot full";
              "Alt+Print" = app "Screenshot (Window)" "${lib.getExe self'.packages.dms-shell} screenshot window";

              # Media keys (audio via DMS so its OSD shows); not listed in the overlay.
              "XF86AudioRaiseVolume" = hidden (dms "audio increment 5");
              "XF86AudioLowerVolume" = hidden (dms "audio decrement 5");
              "XF86AudioMute" = hidden (dms "audio mute");
              "XF86AudioMicMute" = hidden (dms "audio micmute");
              "XF86AudioPlay" = hidden "${lib.getExe pkgs.playerctl} play-pause";
              "XF86AudioStop" = hidden "${lib.getExe pkgs.playerctl} stop";
              "XF86AudioNext" = hidden "${lib.getExe pkgs.playerctl} next";
              "XF86AudioPrev" = hidden "${lib.getExe pkgs.playerctl} previous";

              # Misc
              "Mod+Shift+E" = act "Quit niri" "quit";
              # DMS's themed cheatsheet instead of niri's built-in overlay. It
              # parses ~/.config/niri/config.kdl, which users-dms points at the
              # generated config via /etc/xdg/niri/config.kdl.
              "Mod+Shift+Slash" = app "Keybinds" (dms "keybinds toggle niri");
              "Mod+Escape" = act "Toggle Shortcut Inhibit" "toggle-keyboard-shortcuts-inhibit";
            };
        };
      };
    };
}
