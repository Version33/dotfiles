{

  flake.modules.nixos.sound =
    { pkgs, ... }:
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
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 128; # Very low buffer for high-end CPU (was 1024)
            "default.clock.min-quantum" = 128;
            "default.clock.max-quantum" = 256;
          };
        };

        # Steam's bundled libaudio.so crashes with SIGSEGV in a PulseAudio
        # callback on PipeWire's pulse server. The force-s16-info quirk
        # tells PipeWire to always report S16 sample format, avoiding the
        # crash path in Steam's old audio stack.
        extraConfig.pipewire-pulse."93-steam-compat" = {
          "pulse.rules" = [
            {
              matches = [
                { "application.process.binary" = "steam"; }
              ];
              actions = {
                quirks = [ "force-s16-info" ];
              };
            }
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        pamixer
        pavucontrol
      ];
    };

}
