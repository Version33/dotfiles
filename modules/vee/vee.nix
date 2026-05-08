{

  flake.modules.nixos.vee =
    { self, pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      environment.systemPackages = [
        self.packages.${system}.steam-launcher
        self.packages.${system}.steam-desktop-item
      ];

      # Ensure the correct Steam desktop entry exists for noctalia's launcher.
      # The user-local file takes priority over the system one, and Steam
      # itself may regenerate it. This service overwrites it on every login.
      systemd.user.services.steam-desktop-fix = {
        description = "Ensure Steam desktop entry uses the keepalive launcher";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = toString (pkgs.writeShellScript "steam-desktop-fix" ''
            mkdir -p "$HOME/.local/share/applications"
            cp -f ${self.packages.${system}.steam-desktop-item}/share/applications/steam.desktop \
              "$HOME/.local/share/applications/steam.desktop"
          '');
        };
      };
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
