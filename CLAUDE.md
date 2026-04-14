# CLAUDE.md

Guidance for Claude Code (claude.ai/code) in this repo.

## Commands

```bash
just build          # build without switching (nixos-rebuild build)
just switch         # build and switch (requires sudo)
just test           # build and test without making default
just fmt            # format all .nix files with nixfmt
just check          # lint with statix
just deadcode       # find unused code with deadnix
just update         # update all flake inputs and commit flake.lock
just update-input NAME  # update a single input
just diff           # show closure diff between current and new build
```

`nixos-rebuild build` no sudo. Only `switch`/`test`/`boot` do.

## Architecture

**flake-parts** NixOS config. Entry: `flake.nix` → `flake-parts` via `import-tree ./modules` — every `.nix` under `modules/` auto-imported. **New files must be `git add`ed** before flake evaluator sees.

Two main output types:

- **`perSystem { ... }`** — per-arch packages under `self.packages.<system>.<name>`
- **`flake.modules.nixos.<name> = { ... }`** — NixOS module; all collected + merged into system `k0or` via `builtins.attrValues self.modules.nixos`

### Wrapped packages (`modules/wrapped/`)

Programs needing config baked in: wrapped via `inputs.wrapper-modules.lib.wrapPackage` (or `pkgs.yazi.override` for yazi). Each wrapped file: only `perSystem` pkg — **not** added to `environment.systemPackages`. Installed in logical location:

| Package | Installed in |
|---|---|
| `git`, `lazygit` | `vee/tools/git-tools.nix` |
| `yazi`, `ssh`, `opencode`, `btop` | `vee/tools/cli-tools.nix` |
| `kitty` | `vee/applications.nix` |
| `fish` | `wrapped/fish.nix` (also configures `programs.fish`) |

### Theme pattern

Remote themes: fetched at eval via `builtins.fetchurl` + sha256, consumed via `builtins.fromTOML`/`builtins.readFile` or passed as flag path. Hashes: `nix-prefetch-url <url>`.

### Notable wrapped packages

- **neovim** — split into many files under `modules/wrapped/neovim/`
- **meridian** — custom Node.js build (bun), systemd user service, proxies Claude API
- **opencode** — wires meridian as plugin if present
- **noctalia** — uses `wrapper-modules.wrappers.noctalia-shell.wrap` with settings from `noctalia.json`

### User space (`modules/vee/`)

User config. `_`-prefixed files: disabled/optional. `development/`: dev tooling; `tools/`: CLI pkgs; `audio/`: DAW/audio.