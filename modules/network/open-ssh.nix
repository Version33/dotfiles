{

  flake.modules.nixos.open-ssh = _: {
    # OpenSSH daemon, reachable from the LAN only.
    services.openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "vee@192.168.1.*" ];
      };
    };

    # Accept port 22 only from the local subnet.
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 22 -s 192.168.1.0/24 -j nixos-fw-accept
    '';
  };

}
