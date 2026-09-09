# NixOS Configuration Management

# Default recipe to display help
default:
    @just --list

# Build and switch to the new configuration (nh bundles nom output + nvd diff)
switch:
    nh os switch .

# Build and switch (plain output, fallback option)
switch-plain:
    sudo nixos-rebuild switch --flake .#k0or

# Build and set as boot default without activating now
boot:
    nh os boot .

# Build without switching
build:
    nh os build .

# Update flake inputs, switch to new config, and commit flake.lock
update:
    nix flake update && if git diff --quiet flake.lock; then echo "No updates."; else just switch && git commit flake.lock -m "chore(lock): $(date -I) input bump"; fi

# Update specific input (e.g., just update-input nixpkgs)
update-input INPUT:
    nix flake lock --update-input {{INPUT}}

# Build and test the new configuration without making it default
test:
    nh os test .

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
    nh os build --dry .

# Clean up old generations (keeps last 3 and anything newer than 14 days)
clean:
    nh clean all --keep-since 14d --keep 3

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
    nh os build --out-link ./result .
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
