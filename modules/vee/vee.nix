{

  flake.modules.nixos.vee =
    { self, pkgs, ... }:
    {
      environment.shells = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.fish
      ];

      users.users.vee = {
        isNormalUser = true;
        description = "vee";
        initialPassword = "";
        shell = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
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
      };

      programs = {
        firefox.enable = true;
        steam.enable = true;

        # GameMode for optimizing gaming performance
        gamemode = {
          enable = true;
          settings = {
            general = {
              renice = 10;
            };
          };
        };
      };
    };

}
