{

  flake.modules.nixos.networking = {
    # Enable networking
    networking.hostName = "k0or"; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    # networking.networkmanager.wifi.backend = "iwd";

    networking.wireless.iwd = {
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
    networking.dhcpcd.denyInterfaces = [ "wl*" ];

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # environment.systemPackages = with pkgs; [
    # iwgtk # Lightweight, graphical wifi management utility for Linux
    # impala # TUI for managing wifi
    # ];
  };

}
