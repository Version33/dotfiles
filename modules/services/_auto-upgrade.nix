{

  flake.modules.nixos.auto-upgrade = _: {
    # Scheduled auto upgrade system
    system.autoUpgrade = {
      enable = true;
      operation = "switch"; # If you don't want to apply updates immediately, only after rebooting, use `boot` option in this case
      flake = "/etc/nixos";
      flags = [
        "--update-input"
        "nixpkgs"
        "--commit-lock-file"
      ];
      dates = "weekly";
      # channel = "https://nixos.org/channels/nixos-unstable";
    };

  };

}
