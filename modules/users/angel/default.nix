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
          "networkmanager"
          "input"
          "wheel"
          "video"
          "realtime"
          "audio"
          "tss"
          "plugdev"
        ];
        packages = with self.packages.${system}; [
          git-angel
          ssh-angel
        ];
      };
    };
}
