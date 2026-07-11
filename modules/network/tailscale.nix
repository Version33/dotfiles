{

  flake.modules.nixos.tailscale = _: {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    # Networking
    # Allow Tailscale to manage its own firewall rules
    networking.firewall = {
      # Allow Tailscale UDP port
      allowedUDPPorts = [ 41641 ];
      # Trust Tailscale interface
      trustedInterfaces = [ "tailscale0" ];
    };

  };
}
