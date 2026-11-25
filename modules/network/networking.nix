{
  flake.modules.nixos.networking =
    { pkgs, lib, ... }:
    {
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

      # WORKAROUND(rtl8126-forced-slave): link corrupts frames whenever the NIC resolves as clock master — see WORKAROUNDS.md
      systemd.services.rtl8126-forced-slave = {
        description = "Force the RTL8126 to clock slave";
        wantedBy = [ "multi-user.target" ];
        bindsTo = [ "sys-subsystem-net-devices-enp10s0.device" ];
        after = [ "sys-subsystem-net-devices-enp10s0.device" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "rtl8126-forced-slave" ''
            # The PHY only attaches once networkd brings the link up; until
            # then the setting is rejected.
            for _ in $(${pkgs.coreutils}/bin/seq 60); do
              ${lib.getExe pkgs.ethtool} -s enp10s0 master-slave forced-slave 2>/dev/null && exit 0
              ${pkgs.coreutils}/bin/sleep 0.5
            done
            exit 1
          '';
        };
      };
    };
}
