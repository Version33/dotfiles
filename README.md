# v33's NixOS Configuration

A NixOS configuration.

```bash
# Build and switch to configuration (uses nom for better output)
just switch

# Or manually (plain output)
sudo nixos-rebuild switch --flake .#k0or

# Build without switching (plain output)
just build

# Update flake inputs, switch to new config, and commit flake.lock
just update
```
