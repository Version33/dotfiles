# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    audio-nix.url = "github:polygon/audio.nix";
    flake-file.url = "github:vic/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    forgecode.url = "github:tailcallhq/forgecode";
    import-tree.url = "github:vic/import-tree";
    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
    meridian.url = "github:rynfar/meridian";
    nix-auto-follow.url = "github:fzakaria/nix-auto-follow";
    nixmate.url = "github:daskladas/nixmate";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };
}
