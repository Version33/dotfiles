{

  flake.modules.nixos.tailscale = _: {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      openFirewall = true;
    };

    # Networking
    # Allow Tailscale to manage its own firewall rules
    networking.firewall = {
      # Trust Tailscale interface
      trustedInterfaces = [ "tailscale0" ];
    };

  };
}
