{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      # Built from source by upstream's flake (bun2nix). `.follows = nixpkgs`
      # in modules/flake.nix keeps it on our package set. Bump with
      # `nix flake update oh-my-pi`. No wrapper: omp needs no injected
      # env/flags/config, so it's exposed straight from the input.
      packages.oh-my-pi = inputs.oh-my-pi.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
}
