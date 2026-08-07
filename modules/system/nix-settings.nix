{

  flake.modules.nixos.nix-settings = _: {
    # Nix Settings
    nix = {
      settings = {
        # Enable flakes and new nix command
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        # Performance & Storage Optimization
        auto-optimise-store = true; # Deduplicate identical files via hard links
        max-jobs = 8; # Concurrent derivations; cores = 0 still gives each all 32 threads
        cores = 0; # Use all cores per build job (0 = all available)

        # Network & Download Settings
        http-connections = 50; # Increase from default 25 for faster parallel downloads

        # Binary Caches (Substituters) — nix-community cache speeds up builds
        substituters = [
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        # User Experience
        show-trace = true; # Show stack traces on evaluation errors
        warn-dirty = false; # Don't warn about dirty git trees during development

        # Security & Trust — trusted wheel group for privileged operations
        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      # Garbage Collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      optimise = {
        automatic = true;
        dates = [ "03:45" ];
      };
    };
  };

}
