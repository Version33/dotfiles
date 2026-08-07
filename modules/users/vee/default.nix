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
        initialHashedPassword = "!";
        openssh.authorizedKeys.keyFiles = [ ./keys/phone.pub ];
        shell = self.packages.${system}.fish;
        extraGroups = [
          "input"
          "wheel"
          "video"
          "audio"
          "plugdev"
          "dialout"
        ];
        packages = with self.packages.${system}; [
          git-vee
          ssh-vee
        ];
      };
    };
}
