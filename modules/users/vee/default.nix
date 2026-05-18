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
        ];
        packages = with self.packages.${system}; [
          git-vee
          ssh-vee
        ];
      };

      systemd.user.services.steam-desktop-fix = {
        description = "Ensure Steam desktop entry uses the keepalive launcher";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = toString (
            pkgs.writeShellScript "steam-desktop-fix" ''
              mkdir -p "$HOME/.local/share/applications"
              cp -f ${self.packages.${system}.steam-desktop-item}/share/applications/steam.desktop \
                "$HOME/.local/share/applications/steam.desktop"
            ''
          );
        };
      };
    };
}
