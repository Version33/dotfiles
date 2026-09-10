{
  perSystem =
    { pkgs, inputs', ... }:
    let
      lintsToml = pkgs.writeText "lints.toml" ''
        [lints.clippy]
        # UM, ACTUALLY
        pedantic = { level = "deny", priority = -1 }
        # DEVELOPING LINTS
        nursery = { level = "deny", priority = -1 }
        # DENY PANICS
        unwrap_used = "deny"
        expect_used = "deny"
        indexing_slicing = "deny"
        arithmetic_side_effects = "deny"
        unreachable = "deny"
        unimplemented = "deny"
        unchecked_time_subtraction = "deny"
        todo = "deny"
        string_slice = "deny"
        panic_in_result_fn = "deny"
        panic = "deny"
        exit = "deny"
        as_conversions = "deny"
      '';

      cargoToml = pkgs.writeText "Cargo.toml" ''
        [package]
        name = "__CRATE_NAME__"
        version = "0.1.0"
        edition = "2024"

        [dependencies]
        # COMMAND LINE PARSING
        clap = { version = "4.6.6", features = ["derive"] }
        # ERGONOMIC DATETIMES
        chrono = "0.4.45"
        # SIMPLE PRETTY ERROR HANDLING
        color-eyre = "0.6.5"
        # SUPERPOWERED ITERATORS
        itertools = "0.15.0"
        # PARALELL ITERATORS
        rayon = "1.12.0"
        # SERIALISATION / DESERIALISATION
        serde = { version = "1.0", features = ["derive"] }

        [dev-dependencies]
        # BENCHMARKING
        criterion = "0.8.2"

        [[bench]]
        name = "bench"
        harness = false

      '';

      mainRs = pkgs.writeText "main.rs" ''
        //! __CRATE_NAME__

        use clap::Parser;
        use color_eyre::eyre::Result;

        /// Command line arguments.
        #[derive(Debug, Parser)]
        #[command(version, about)]
        struct Cli {
            /// Who to greet.
            #[arg(default_value = "world")]
            name: String,
        }

        /// Builds the greeting printed by this program.
        #[must_use]
        pub fn greeting(name: &str) -> String {
            format!("hello, {name}!")
        }

        fn main() -> Result<()> {
            color_eyre::install()?;

            let Cli { name } = Cli::parse();
            println!("{}", greeting(&name));

            Ok(())
        }

        #[cfg(test)]
        mod tests {
            use super::greeting;

            #[test]
            fn greets_by_name() {
                assert_eq!(greeting("world"), "hello, world!");
            }
        }
      '';

      libRs = pkgs.writeText "lib.rs" ''
        //! __CRATE_NAME__

        /// Builds a greeting for `name`.
        #[must_use]
        pub fn greeting(name: &str) -> String {
            format!("hello, {name}!")
        }

        #[cfg(test)]
        mod tests {
            use super::greeting;

            #[test]
            fn greets_by_name() {
                assert_eq!(greeting("world"), "hello, world!");
            }
        }
      '';

      benchRs = pkgs.writeText "bench.rs" ''
        //! Criterion benchmarks for __CRATE_NAME__.
        //!
        //! Run with `cargo bench`; `cargo nextest run` skips bench targets.

        use std::hint::black_box;

        use criterion::{Criterion, criterion_group, criterion_main};

        fn greeting(name: &str) -> String {
            format!("hello, {name}!")
        }

        fn bench_greeting(c: &mut Criterion) {
            c.bench_function("greeting", |b| b.iter(|| greeting(black_box("world"))));
        }

        criterion_group!(benches, bench_greeting);
        criterion_main!(benches);
      '';

      nextestToml = pkgs.writeText "nextest.toml" ''
        # cargo-nextest configuration — https://nexte.st/docs/configuration/
        [profile.default]
        # Show each failure as it happens, then repeat them in the final summary.
        failure-output = "immediate-final"
        # Run the whole suite instead of stopping at the first failure.
        fail-fast = false
        # Call out slow tests at the end of the run.
        final-status-level = "slow"
        # Warn after 30s, kill the test after 4 warnings.
        slow-timeout = { period = "30s", terminate-after = 4 }

        [profile.ci]
        failure-output = "immediate-final"
        fail-fast = false
        status-level = "fail"
        final-status-level = "flaky"
        retries = 2

        [profile.ci.junit]
        path = "junit.xml"
      '';

      gitignore = pkgs.writeText "gitignore" ''
        /target
      '';

      # `cargo clippy --all-targets` compiles #[cfg(test)] code too, so the deny
      # list above would also ban `.unwrap()` in unit tests without this carve-out.
      clippyToml = pkgs.writeText "clippy.toml" ''
        allow-unwrap-in-tests = true
        allow-expect-in-tests = true
        allow-panic-in-tests = true
        allow-indexing-slicing-in-tests = true
      '';

      baconToml = pkgs.writeText "bacon.toml" ''
        #:schema https://dystroy.org/bacon/.bacon.schema.json
        # bacon configuration — https://dystroy.org/bacon/config/

        # The strict [lints.clippy] table is the point of this crate, so a bare
        # `bacon` watches clippy across every target, tests included.
        default_job = "clippy-all"
      '';
    in
    {
      packages = {
        rust-init = pkgs.writeShellApplication {
          name = "rust-init";
          runtimeInputs = with pkgs; [
            coreutils
            gnugrep
            gnused
            git
          ];
          text = ''
            usage() {
              cat <<'USAGE'
            rust-init — scaffold a Rust crate with the default lints, deps, bacon and nextest setup

              rust-init <name>         new binary crate in ./<name>
              rust-init --lib <name>   new library crate in ./<name>
              rust-init --lints [dir]  add the default [lints.clippy] table and clippy.toml to an existing crate
            USAGE
            }

            if [ "$#" -eq 0 ]; then
              usage >&2
              exit 2
            fi

            kind=bin

            case "$1" in
            -h | --help)
              usage
              exit 0
              ;;
            --lints)
              shift
              dir=.
              if [ "$#" -gt 0 ]; then
                dir=$1
              fi
              manifest=$dir/Cargo.toml
              if [ ! -f "$manifest" ]; then
                echo "rust-init: no Cargo.toml in $dir" >&2
                exit 1
              fi
              if grep -q '^\[lints' "$manifest"; then
                echo "rust-init: $manifest already has a [lints] table" >&2
                exit 1
              fi
              printf '\n' >>"$manifest"
              cat ${lintsToml} >>"$manifest"
              echo "rust-init: appended [lints.clippy] to $manifest"
              if [ -e "$dir/clippy.toml" ]; then
                echo "rust-init: kept existing $dir/clippy.toml"
              else
                install -m 644 ${clippyToml} "$dir/clippy.toml"
                echo "rust-init: wrote $dir/clippy.toml"
              fi
              exit 0
              ;;
            --lib)
              kind=lib
              shift
              ;;
            esac

            if [ "$#" -ne 1 ]; then
              usage >&2
              exit 2
            fi

            name=$1
            case "$name" in
            [0-9]* | *[!A-Za-z0-9_-]*)
              echo "rust-init: invalid crate name: $name" >&2
              exit 1
              ;;
            esac

            if [ -e "$name" ]; then
              echo "rust-init: ./$name already exists" >&2
              exit 1
            fi

            mkdir -p "$name/src" "$name/benches" "$name/.config"
            cat ${cargoToml} ${lintsToml} >"$name/Cargo.toml"
            cp ${clippyToml} "$name/clippy.toml"
            cp ${baconToml} "$name/bacon.toml"
            cp ${nextestToml} "$name/.config/nextest.toml"
            cp ${benchRs} "$name/benches/bench.rs"
            cp ${gitignore} "$name/.gitignore"
            if [ "$kind" = lib ]; then
              cp ${libRs} "$name/src/lib.rs"
            else
              cp ${mainRs} "$name/src/main.rs"
            fi

            chmod -R u+w "$name"
            sed -i "s/__CRATE_NAME__/$name/g" "$name/Cargo.toml" "$name"/src/*.rs "$name"/benches/*.rs

            if ! git -C "$name" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
              git -C "$name" init --quiet --initial-branch=main
            fi

            echo "rust-init: created $kind crate ./$name"
            echo "  cd $name"
            echo "  bacon                                            # watch the strict lints"
            echo "  cargo clippy --all-targets && cargo nextest run"
          '';
        };

        rust-watch = pkgs.writeShellApplication {
          name = "rust-watch";
          runtimeInputs = [ pkgs.watchexec ];
          text = ''
            cmd="cargo run -q"
            if [ "$#" -gt 0 ]; then
              cmd="$*"
            fi

            export RUSTFLAGS=-Awarnings
            # RUSTFLAGS is part of cargo's fingerprint; isolate to target/watch so
            # switching between rust-watch and plain cargo/clippy/bacon skips a full rebuild.
            export CARGO_TARGET_DIR=target/watch
            exec watchexec -r --clear=reset -e rs --wrap-process=none "$cmd"
          '';
        };

        # Shared with neovim's rust-analyzer so the editor can't drift off the compiler.
        rust-toolchain =
          let
            fenix = inputs'.fenix.packages;
          in
          fenix.combine [
            # `latest`, not `complete`: the only nightly profile fenix also builds for
            # cross targets, keeping rustc and the wasm rust-std on the same date.
            fenix.latest.rustc
            fenix.latest.cargo
            fenix.latest.rustfmt
            fenix.latest.clippy
            # Matches the compiler's proc-macro ABI, unlike nixpkgs' stable build.
            fenix.latest.rust-analyzer
            fenix.latest.rust-src
            fenix.targets.wasm32-unknown-unknown.latest.rust-std
          ];
      };
    };

  flake.modules.nixos.dev-rust =
    {
      pkgs,
      self,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      environment.systemPackages = [
        # Declarative nightly toolchain: rustc, cargo, clippy, rustfmt,
        # rust-analyzer, rust-src and the wasm32-unknown-unknown target
        self.packages.${system}.rust-toolchain

        # Scaffold crates with the default lints, deps, bacon and nextest config
        self.packages.${system}.rust-init

        # `rust-watch [cmd]` — re-run on .rs changes, warnings muted
        self.packages.${system}.rust-watch
      ]
      ++ (with pkgs; [
        # Watch runner for the strict lints — `bacon`, `bacon nextest`
        bacon

        # Dioxus (Rust UI framework)
        dioxus-cli

        # Task runner
        cargo-make

        # WASM tooling
        wasm-pack # Build Rust-generated WASM packages
        trunk # Bundle Rust WASM web apps
        binaryen # wasm-opt and other WASM tools

        # Cargo extensions
        cargo-edit # `cargo add`, `cargo rm`, `cargo upgrade`
        cargo-audit # Audit Cargo.lock for security advisories
        cargo-watch # `cargo watch` — re-run on file changes
        cargo-nextest # Faster test runner with better output
        cargo-outdated # Check for outdated dependencies

        # Build dependencies
        pkg-config
        openssl
      ]);

      # `cargo nt` runs nextest; `cargo test` stays too since nextest skips doctests.
      environment.variables.CARGO_ALIAS_NT = "nextest run";
    };
}
