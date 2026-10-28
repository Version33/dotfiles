{
  perSystem =
    { pkgs, ... }:
    {
      # nixpkgs `omp` (pkgs/by-name/om/omp), prebuilt on Hydra. Exposed under
      # the old attr name so users/packages.nix and the neovim keymap keep
      # working. Version follows the nixpkgs input: `nix flake update nixpkgs`.
      # No wrapper: omp needs no injected env/flags/config.
      packages.oh-my-pi = pkgs.omp;
    };
}
