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
        # WORKAROUND(dhcpcd-noipv4ll): IPv4LL fallback after resume purges the real default route — see WORKAROUNDS.md
        extraConfig = "noipv4ll";
      };
    };
  };
}
