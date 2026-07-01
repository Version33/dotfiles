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

      environment.systemPackages = with pkgs; [
        pamixer
        pavucontrol
      ];
    };

}
