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
            "default.clock.quantum" = 128;
            "default.clock.min-quantum" = 128;
            "default.clock.max-quantum" = 256;
          };
        };
      };

      # Steam's bundled libaudio.so derefs each PulseAudio card's active profile
      # without a NULL check, and these GPU HDMI cards sometimes come up with no
      # profile at all, segfaulting Steam on launch. Unused here — audio goes out
      # the EVO 8. Drop this block to get monitor audio back in pavucontrol.
      environment.etc."wireplumber/wireplumber.conf.d/50-disable-gpu-hdmi-audio.conf".text = ''
        monitor.alsa.rules = [
          {
            matches = [
              { device.name = "alsa_card.pci-0000_03_00.1" }
              { device.name = "alsa_card.pci-0000_7b_00.1" }
            ]
            actions = {
              update-props = {
                device.disabled = true
              }
            }
          }
        ]
      '';

      environment.systemPackages = with pkgs; [
        pamixer
        pavucontrol
      ];
    };

}
