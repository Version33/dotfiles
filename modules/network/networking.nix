{
  flake.modules.nixos.networking = {
    networking = {
      hostName = "k0or";

      wireless.iwd = {
        enable = true;
        settings = {
          General.EnableNetworkConfiguration = true;
          Network.EnableIPv6 = true;
          Scan.DisablePeriodicScan = true;
        };
      };

      # iwd runs its own DHCP (EnableNetworkConfiguration); keep dhcpcd off wl*
      # so the two clients don't race.
      dhcpcd = {
        denyInterfaces = [ "wl*" ];
        # After resume the DHCP rebind often times out (~5s) and dhcpcd falls
        # back to an IPv4LL address + default route; when the real lease lands
        # ~1s later and the 169.254.x address is removed, the kernel purges the
        # freshly installed default route with it ("pid 0 deleted default
        # route via 192.168.1.254") -> no IPv4 until the cable is replugged.
        extraConfig = "noipv4ll";
      };
    };
  };
}
