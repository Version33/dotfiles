{

  flake.modules.nixos.networking = {
    networking = {
      hostName = "k0or";
      # Pick only one of the below networking options.
      # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      # networkmanager.enable = true;  # Easiest to use and most distros use this by default.
      # networkmanager.wifi.backend = "iwd";

      wireless.iwd = {
        enable = true;
        settings = {
          General = {
            EnableNetworkConfiguration = true;
          };
          Network = {
            EnableIPv6 = true;
          };
          Scan = {
            DisablePeriodicScan = true;
          };
        };
      };

      # iwd already runs its own DHCP client on wireless
      # (General.EnableNetworkConfiguration above); keep dhcpcd (enabled by the
      # networking.useDHCP default for ethernet) off wl* so two clients don't
      # race for the same interface.
      dhcpcd.denyInterfaces = [ "wl*" ];

      # Configure network proxy if necessary
      # proxy.default = "http://user:password@proxy:port/";
      # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    };

    # environment.systemPackages = with pkgs; [
    # iwgtk # Lightweight, graphical wifi management utility for Linux
    # impala # TUI for managing wifi
    # ];
  };

}
