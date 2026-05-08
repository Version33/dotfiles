{ inputs, ... }:
{
  # Rust toolchain overlay (for optional rust.nix module)
  flake-file.inputs.rust-overlay.url = "github:oxalica/rust-overlay";

  flake.modules.nixos.rust =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

      environment.systemPackages = with pkgs; [
        (rust-bin.fromRustupToolchainFile ./rust-toolchain.toml)
        taplo # toml formatter & lsp
        cargo-watch
        cargo-deny
        cargo-audit
        cargo-update
        cargo-edit
        cargo-outdated
        cargo-license
        cargo-tarpaulin
        cargo-cross
        cargo-zigbuild
        cargo-nextest
        cargo-spellcheck
        cargo-modules
        cargo-bloat
        cargo-unused-features
        cargo-feature
        cargo-features-manager
        bacon
        evcxr # rust repl
      ];
    };

}
