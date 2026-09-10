{

  flake.modules.nixos.sound =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
        # If you want to use JACK applications, uncomment this
        jack.enable = true;

        # Low-latency quantum (128-256) for gaming; needs a fast CPU to avoid xruns.
        extraConfig.pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.quantum" = 128;
            "default.clock.min-quantum" = 128;
            "default.clock.max-quantum" = 256;
          };
        };
      };

      # WirePlumber can finish ALSA probing with a card reporting zero profiles;
      # pipewire-pulse then exposes a NULL active profile, which crashes Steam's
      # bundled libaudio.so on launch. Restarting wireplumber re-probes correctly.
      systemd.user.services.wireplumber-reprobe = {
        description = "Re-probe ALSA cards that came up with no profiles";
        wantedBy = [ "graphical-session.target" ];
        after = [
          "graphical-session.target"
          "pipewire.service"
        ];
        unitConfig.ConditionUser = "!@system";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = toString (
            pkgs.writeShellScript "wireplumber-reprobe" ''
              # Verdict: "broken"/"ok"/"" (empty = pw-dump/jq not ready, retry).
              verdict() {
                ${config.services.pipewire.package}/bin/pw-dump 2>/dev/null \
                  | ${lib.getExe pkgs.jq} -r 'if any(.[];
                      .type == "PipeWire:Interface:Device"
                      and .info.props."device.api" == "alsa"
                      and (.info.params.Profile | length) > 0
                      and (.info.params.EnumProfile | length) == 0)
                    then "broken" else "ok" end' 2>/dev/null
              }
              for _ in 1 2 3 4 5; do
                case "$(verdict)" in
                  ok) exit 0 ;;
                  broken) ${config.systemd.package}/bin/systemctl --user restart wireplumber.service ;;
                esac
                ${pkgs.coreutils}/bin/sleep 3
              done
            ''
          );
        };
      };

      environment.systemPackages = with pkgs; [
        pamixer
        pavucontrol
      ];
    };

}
