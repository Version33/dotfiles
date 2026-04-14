{
  flake.modules.nixos.git-tools =
    { self, pkgs, ... }:
    {
      # Git ecosystem tools
      environment.systemPackages =
        (with pkgs; [
          delta
          gh
          bat
          git-ignore
          gitleaks
          git-secrets
        ])
        ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
          git
          lazygit
        ]);
    };
}
