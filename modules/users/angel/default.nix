{
  flake.modules.nixos.users-angel =
    { self, pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      users.users.angel = {
        isNormalUser = true;
        description = "angel";
        initialHashedPassword = "!";
        shell = self.packages.${system}.fish;
        extraGroups = [
          "input"
          "video"
          "audio"
          "plugdev"
        ];
        packages = with self.packages.${system}; [
          git-angel
          ssh-angel
        ];
      };
    };
}
