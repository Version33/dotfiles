{
  flake.modules.nixos.users-vee =
    { self, pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      users.users.vee = {
        isNormalUser = true;
        description = "vee";
        initialPassword = "";
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
          "games"
        ];
        packages = with self.packages.${system}; [
          git-vee
          ssh-vee
        ];
      };
    };
}
