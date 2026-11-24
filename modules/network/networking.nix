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

      # WORKAROUND(rtl8126-resume-retrain): software re-plug of the wired link after resume — see WORKAROUNDS.md
      systemd.services.rtl8126-resume-retrain = {
        description = "Renegotiate the RTL8126 link after resume";
        wantedBy = [ "suspend.target" ];
        after = [ "suspend.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "rtl8126-resume-retrain" ''
            # Retrain only once the resume-time negotiation has finished;
            # restarting it mid-flight is what resume already does.
            for _ in $(${pkgs.coreutils}/bin/seq 20); do
              [ "$(${pkgs.coreutils}/bin/cat /sys/class/net/enp10s0/carrier 2>/dev/null)" = 1 ] && break
              ${pkgs.coreutils}/bin/sleep 0.5
            done
            exec ${lib.getExe pkgs.ethtool} -r enp10s0
          '';
        };
      };
    };
}
