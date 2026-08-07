# NixOS Configuration Management

# Default recipe to display help
default:
    @just --list

# Build and switch to the new configuration (with nom for better output)
switch:
    nom build '.#nixosConfigurations.k0or.config.system.build.toplevel' && sudo nixos-rebuild switch --flake .#k0or

# Build and switch (plain output, fallback option)
switch-plain:
    sudo nixos-rebuild switch --flake .#k0or

# Build without switching
build:
    nixos-rebuild build --flake .#k0or

# Update flake inputs, switch to new config, and commit flake.lock
update:
    nix flake update && if git diff --quiet flake.lock; then echo "No updates."; else just switch && git commit flake.lock -m "chore(lock): $(date -I) input bump"; fi

# Update specific input (e.g., just update-input nixpkgs)
update-input INPUT:
    nix flake lock --update-input {{INPUT}}

# Build and test the new configuration without making it default (with nom for better output)
test:
    nom build '.#nixosConfigurations.k0or.config.system.build.toplevel' && sudo nixos-rebuild test --flake .#k0or

# Build and test (plain output, fallback option)
test-plain:
    sudo nixos-rebuild test --flake .#k0or

# Format all nix files
fmt:
    nix fmt

# Check for issues with statix
check:
    statix check .

# Find and remove unused code
deadcode:
    deadnix .

# Check flake and show any errors (with nom for better output)
flake-check:
    nom flake check

# Check flake (plain output, fallback option)
flake-check-plain:
    nix flake check

# Show flake metadata
flake-info:
    nix flake metadata

# Show what would be built/downloaded
dry-run:
    nixos-rebuild dry-build --flake .#k0or

# Clean up generations older than 30 days, then rebuild boot entries
clean:
    sudo nix-collect-garbage --delete-older-than 30d
    sudo nixos-rebuild switch --flake .#k0or

# List all generations
generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Show disk usage of /nix, plus the current system's closure size
disk-usage:
    df -h /nix
    nix path-info -Sh /run/current-system

# Optimize nix store
optimize:
    sudo nix-store --optimize

# Show system configuration diff
diff:
    nixos-rebuild build --flake .#k0or
    nix store diff-closures /run/current-system ./result

# Git commit with conventional message
commit MESSAGE:
    git add .
    git commit -m '{{MESSAGE}}'

# Quick commit and switch
quick MESSAGE: switch (commit MESSAGE)

# Show dependency tree (requires nix-tree)
tree:
    nix-tree /run/current-system

# Search for a package
search PACKAGE:
    nix search nixpkgs {{PACKAGE}}

# Enter development shell
dev:
    nix develop
