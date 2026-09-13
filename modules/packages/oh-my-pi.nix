{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      # Built from source by upstream's flake (bun2nix). `.follows = nixpkgs`
      # in modules/flake.nix keeps it on our package set. Bump with
      # `nix flake update oh-my-pi`. No wrapper: omp needs no injected
      # env/flags/config.
      packages.oh-my-pi = inputs.oh-my-pi.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (prev: {
        # Upstream 93aaa52 imports `chalk` in collab-cli.ts without declaring
        # it in packages/coding-agent/package.json; the hoisted dev install
        # hides that, bun's isolated linker in the Nix build does not. Only
        # `.dim`/`.green` are used. `--replace-fail` breaks the build the moment
        # upstream fixes or reshapes the import: delete this override then.
        postPatch = (prev.postPatch or "") + ''
          substituteInPlace packages/coding-agent/src/cli/collab-cli.ts \
            --replace-fail 'import chalk from "chalk";' \
              'const chalk = { dim: (s: string) => `\x1b[2m''${s}\x1b[22m`, green: (s: string) => `\x1b[32m''${s}\x1b[39m` };'
        '';
      });
    };
}
