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
    flake-parts.url = "github:hercules-ci/flake-parts"; # Module system for flakes
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

    # Freenet peer (freenet.org). Deliberately does NOT follow our nixpkgs:
    # the freenet build needs a newer rustc than nixos-unstable may carry.
    freenet.url = "github:freenet/freenet-core";

    # Audio
    audio-nix = {
      url = "github:polygon/audio.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # EVO 8 audio interface control
    evo-control = {
      url = "github:briannadon/evo-control";
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
