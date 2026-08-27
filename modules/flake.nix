{ inputs, self, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.flake-file.flakeModules.default
  ];

  # Configure flake-file
  flake-file.outputs = "inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)";

  # Define core flake inputs here
  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Core system packages
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    }; # Module system for flakes
    import-tree.url = "github:vic/import-tree"; # Automatic module discovery

    # Program wrappers
    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Boilerplate reduction tools
    flake-file.url = "github:vic/flake-file"; # Generates flake.nix from modules
    nix-auto-follow = {
      url = "github:fzakaria/nix-auto-follow";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Security
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop / WM

    # Development
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tools
    nixmate = {
      url = "github:daskladas/nixmate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Eye tracking
    tobiifree = {
      url = "github:Aetherall/tobiifree";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Freenet peer (freenet.org). Now follows our nixpkgs — our rustc (≥1.97)
    # is newer than what the build needs (≥1.94).
    freenet = {
      url = "github:freenet/freenet-core";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Audio
    audio-nix = {
      url = "github:polygon/audio.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ableton Live runtime (patched Wine + PipeASIO + Link). Tracks main.
    # Deliberately NOT following our nixpkgs: the input carries a heavy
    # patched-Wine build, so keep upstream's pinned nixpkgs and only rebuild
    # when the project itself updates.
    ableton-linux.url = "github:shibco/ableton-linux";

    # EVO 8 audio interface control
    # Pinned to a specific rev: this builds an out-of-tree kernel module
    # (evo_raw) via a brittle Makefile patch — bump deliberately, not via
    # an unpinned `nix flake update`.
    evo-control = {
      url = "github:briannadon/evo-control?rev=17043c73fa48378d130f9d85b14d687f886f2881";
      flake = false;
    };

    # OrcaSlicer nightly AppImage (Bambu H2C support; not in a tagged release
    # yet). Upstream overwrites this asset in place; the lock pins a snapshot.
    # Bump with `nix flake update orca-nightly`.
    orca-nightly = {
      url = "file+https://github.com/OrcaSlicer/OrcaSlicer/releases/download/nightly-builds/OrcaSlicer_Linux_AppImage_Ubuntu2404_nightly.AppImage";
      flake = false;
    };

    # fee[dB]ack nightly AppImage. `nightly` is a rolling tag — upstream
    # re-uploads the same asset URL on every build; the lock pins a snapshot.
    # Bump with `nix flake update feedback-nightly`.
    feedback-nightly = {
      url = "file+https://github.com/got-feedback/feedBack-desktop/releases/download/nightly/feedback-0.3.0-x86_64.AppImage";
      flake = false;
    };
  };

  # System architectures this flake supports
  systems = [ "x86_64-linux" ];

  # NixOS system configurations
  flake.nixosConfigurations = {
    k0or = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self;
      };
      modules = [
        ../hardware-configuration.nix
      ]
      # Load all dendritic NixOS modules
      ++ (builtins.attrValues self.modules.nixos);
    };
  };

}
