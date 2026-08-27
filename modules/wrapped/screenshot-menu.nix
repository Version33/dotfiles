{
  perSystem =
    { pkgs, ... }:
    let
      # Matches noctalia (Noto Sans) and catppuccin mocha.
      fuzzelConfig = pkgs.writeText "screenshot-menu-fuzzel.ini" ''
        [main]
        font=Noto Sans:size=13, JetBrainsMono Nerd Font Propo:size=13
        width=34
        horizontal-pad=18
        vertical-pad=12
        inner-pad=8

        [colors]
        background=1e1e2ef2
        text=cdd6f4ff
        prompt=bac2deff
        input=cdd6f4ff
        match=cba6f7ff
        selection=45475aff
        selection-text=cdd6f4ff
        selection-match=cba6f7ff
        border=cba6f7ff

        [border]
        width=2
        radius=12
      '';
    in
    {
      # Unified capture menu for niri: screenshots (region / window / monitor)
      # through niri's native actions — same clipboard + file behaviour as the
      # Print binds — and screen recording (region / monitor, optionally with
      # system audio or microphone) through wl-screenrec's hardware encoder.
      # Invoking the menu while a recording is running offers "Stop recording".
      packages.screenshot-menu = pkgs.writeShellApplication {
        name = "screenshot-menu";
        runtimeInputs = with pkgs; [
          coreutils
          fuzzel
          grim
          jq
          libnotify
          niri # `niri msg` IPC client; protocol-compatible with the wrapped session binary
          procps # pgrep/pkill
          pulseaudio # pactl, to resolve the default sink's monitor source
          slurp
          util-linux # setsid, to detach wl-screenrec from this script
          wl-clipboard
          wl-screenrec
        ];
        text = ''
          state="''${XDG_RUNTIME_DIR:-/tmp}/screenshot-menu.recording"
          shots="$HOME/Pictures/Screenshots"
          recs="$HOME/Videos/Recordings"

          # Same naming convention as niri's default screenshot-path.
          stamp() { date '+%Y-%m-%d %H-%M-%S'; }

          menu() { # $1 = prompt, $2 = line count; options on stdin
            fuzzel --dmenu --config ${fuzzelConfig} --prompt "$1 ❯ " --lines "$2"
          }

          notify() { # $1 = summary, $2 = body, $3 = optional image
            if [ -n "''${3:-}" ]; then
              notify-send -a Capture -i "$3" "$1" "$2"
            else
              notify-send -a Capture "$1" "$2"
            fi
          }

          shot_saved() {
            notify "Screenshot saved" "$1 — copied to clipboard." "$1"
          }

          pick_monitor() { # click a monitor, prints its output name
            slurp -o -r -f '%o'
          }

          pick_audio() { # fills AUDIO; non-zero on cancel
            local mode
            mode=$(printf '%s\n' "󰝟  No audio" "󰕾  System audio" "󰍬  Microphone" \
              | menu "Audio" 3) || return 1
            case "$mode" in
              *"System audio") AUDIO=(--audio --audio-device "$(pactl get-default-sink).monitor") ;;
              *"Microphone") AUDIO=(--audio) ;;
              *) AUDIO=() ;;
            esac
          }

          start_record() { # $@ = wl-screenrec capture args
            mkdir -p "$recs"
            local file
            file="$recs/Recording from $(stamp).mp4"
            printf '%s' "$file" >"$state"
            setsid -f wl-screenrec "$@" -f "$file" >/dev/null 2>&1
            notify "Recording started" "Open the capture menu again to stop."
          }

          stop_record() {
            local file=""
            if [ -f "$state" ]; then file=$(<"$state"); fi
            # SIGINT makes wl-screenrec finalize the container cleanly.
            pkill -x -INT wl-screenrec || true
            for _ in $(seq 1 50); do
              pgrep -x wl-screenrec >/dev/null || break
              sleep 0.1
            done
            rm -f "$state"
            if [ -n "$file" ] && [ -f "$file" ]; then
              notify "Recording saved" "$file"
            else
              notify "Recording stopped" ""
            fi
          }

          recording=0
          if pgrep -x wl-screenrec >/dev/null; then recording=1; fi

          opts=()
          if ((recording)); then opts+=("󰓛  Stop recording"); fi
          opts+=("󰆞  Screenshot region" "󰖯  Screenshot window" "󰍹  Screenshot monitor")
          if ((!recording)); then opts+=("󰕧  Record region" "󰕧  Record monitor"); fi

          choice=$(printf '%s\n' "''${opts[@]}" | menu "Capture" "''${#opts[@]}") || exit 0

          AUDIO=()
          case "$choice" in
            *"Stop recording")
              stop_record
              ;;
            *"Screenshot region")
              # niri's interactive screenshot UI (same as plain Print).
              exec niri msg action screenshot
              ;;
            *"Screenshot window")
              # Click any window; Escape cancels (pick-window returns null).
              id=$(niri msg --json pick-window 2>/dev/null | jq -r '.id // empty' || true)
              [ -n "$id" ] || exit 0
              mkdir -p "$shots"
              file="$shots/Screenshot from $(stamp).png"
              niri msg action screenshot-window --id "$id" --path "$file"
              shot_saved "$file"
              ;;
            *"Screenshot monitor")
              output=$(pick_monitor) || exit 0
              mkdir -p "$shots"
              file="$shots/Screenshot from $(stamp).png"
              grim -o "$output" "$file"
              wl-copy <"$file"
              shot_saved "$file"
              ;;
            *"Record region")
              geometry=$(slurp) || exit 0
              pick_audio || exit 0
              start_record -g "$geometry" "''${AUDIO[@]}"
              ;;
            *"Record monitor")
              output=$(pick_monitor) || exit 0
              pick_audio || exit 0
              start_record -o "$output" "''${AUDIO[@]}"
              ;;
          esac
        '';
      };
    };
}
