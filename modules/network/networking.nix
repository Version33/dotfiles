{
  flake.modules.nixos.networking = {
    networking = {
      hostName = "k0or";

      # systemd-networkd owns L3 on every link (DHCP, RA, routes) through the
      # stock 99-*-dhcp units; wired gets metric 1024, WiFi 1025. It is also
      # the only non-NetworkManager source DMS reads wired state from.
      useNetworkd = true;

      # Association only; networkd does the rest. iwd needs the MT7925 driver
      # loaded: DMS aborts its whole network backend (wired included) when
      # iwd is on the bus without a device.
      wireless.iwd = {
        enable = true;
        settings.Scan.DisablePeriodicScan = true;
      };
    };
  };
}
