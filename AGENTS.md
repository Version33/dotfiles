# Agent Guidelines

This document provides essential context for AI agents working in this NixOS configuration repository.

## 🚀 Essential Commands

Most operations are managed via `just`.

| Command | Description | Note |
|---|---|---|
| `just build` | Build configuration without switching | Uses `nixos-rebuild build` |
| `just switch` | Build and switch to new config | **Requires `sudo`** |
| `just test` | Build and test without switching | **Requires `sudo`** |
| `just fmt` | Format all `.nix` files | Uses `nixfmt` |
| `just check` | Lint with `statix` | |
| `just deadcode`| Find unused code | Uses `deadnix` |
| `just update` | Update flake inputs & commit | |
| `just diff` | Show closure diff | Compare current vs new build |
| `just dev` | Enter development shell | `nix develop` |

**Note**: `nixos-rebuild build` does **not** require `sudo`. Commands that modify the system state (`switch`, `test`, `boot`) **do** require `sudo`.

## 🏗️ Architecture & Organization

The repository uses `flake-parts` to manage a modular NixOS configuration.

### Core Mechanism
- **Entry Point**: `flake.nix`
- **Auto-import**: All files under `modules/` are automatically imported into the flake via `import-tree ./modules`.
- **New Files**: Any new `.nix` file added to `modules/` **must be `git add`ed** before the flake evaluator will recognize it.

### Module Types
1. **System Modules**: Defined via `flake.modules.nixos.<name>`. These are merged into the system configuration.
   - Example: `modules/system/`, `modules/network/`, `modules/vee/`
2. **Per-System Packages**: Defined via `perSystem`. These are available as packages under `self.packages.<system>.<name>`.
   - Useful for standalone tools or testing specific configurations.

### Directory Structure
- `modules/system/`: Core system settings (nixpkgs, time, etc.).
- `modules/hardware/`: Hardware-specific configurations (drivers, udev, etc.).
- `modules/network/`: Networking stack (DNS, VPN, Firewall, etc.).
- `modules/vee/`: User-specific configuration (apps, audio, dev tools).
- `modules/wrapped/`: Programs that require specific configuration baked in (Neovim, Git, etc.).
- `modules/services/`: System and user services (AI services, fonts, etc.).

## 🛠️ Development Patterns

### Wrapped Packages (`modules/wrapped/`)
Programs that need specific configuration (like Neovim or Git) are often "wrapped" using `inputs.wrapper-modules.lib.wrapPackage`.
- These are provided as `perSystem` packages.
- They are **not** automatically added to `environment.systemPackages` unless explicitly defined in a NixOS module.

### Neovim Configuration
Neovim is highly modularized under `modules/wrapped/neovim/`.
- It uses `nvf` for configuration.
- Options are defined in `modules/wrapped/neovim/options.nix`.
- Lua logic is often split into `modules/wrapped/neovim/lua/`.

### Theme Pattern
Themes are often fetched at evaluation time using `builtins.fetchurl` with a `sha256` hash.

## ⚠️ Gotchas & Non-Obvious Details

- **Git Tracking**: Always `git add` new modules immediately. The flake-parts `import-tree` won't see them otherwise.
- **Unfree Packages**: `nixpkgs.config.allowUnfree` is enabled globally in `modules/system/nixpkgs.nix`.
- **User Space**: Files prefixed with `_` in `modules/vee/` are intended to be disabled or optional.
- **Shell**: The default shell for the user `vee` is configured as `fish` via a wrapped package.
- **Sudo usage**: Be careful when running `just` commands. Use `just build` for safe testing and `just switch` only when ready to apply changes.
