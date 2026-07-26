{
  flake.modules.nixos.dev-rust =
    { inputs, pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      fenix = inputs.fenix.packages.${system};
      rust-toolchain = fenix.combine [
        fenix.stable.rustc
        fenix.stable.cargo
        fenix.stable.rustfmt
        fenix.stable.clippy
        fenix.targets.wasm32-unknown-unknown.stable.rust-std
      ];
    in
    {
      environment.systemPackages = with pkgs; [
        # Declarative Rust toolchain with wasm32-unknown-unknown target
        rust-toolchain

        # Language server
        rust-analyzer

        # Dioxus (Rust UI framework)
        dioxus-cli

        # Task runner
        cargo-make

        # WASM tooling
        wasm-pack    # Build Rust-generated WASM packages
        trunk        # Bundle Rust WASM web apps
        binaryen     # wasm-opt and other WASM tools

        # Cargo extensions
        cargo-edit       # `cargo add`, `cargo rm`, `cargo upgrade`
        cargo-audit      # Audit Cargo.lock for security advisories
        cargo-watch      # `cargo watch` — re-run on file changes
        cargo-nextest    # Faster test runner with better output
        cargo-outdated   # Check for outdated dependencies

        # Build dependencies
        pkg-config
        openssl
      ];
    };
}
