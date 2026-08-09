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

        # Low-latency configuration for gaming
        # This reduces audio stuttering in games like CS2
        # With a high-end CPU, we can use very low buffer sizes
        extraConfig.pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.quantum" = 128;
            "default.clock.min-quantum" = 128;
            "default.clock.max-quantum" = 256;
          };
        };
      };

      # WirePlumber sometimes finishes its ALSA probe with a card that enumerates
      # zero profiles. pipewire-pulse then reports a NULL active profile for it,
      # and Steam's bundled libaudio.so derefs that without a NULL check and
      # segfaults on launch. Which card loses the race varies between boots, so
      # re-probe once the session is up; a warm restart has always enumerated
      # correctly.
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
              # "broken" / "ok" / "" — an empty verdict means pw-dump or jq
              # failed (PipeWire not up yet), which must retry rather than be
              # mistaken for a healthy graph.
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
