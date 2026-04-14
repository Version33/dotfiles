{
  flake.modules.nixos.applications =
    { self, pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
      ]
      ++ (with pkgs; [
        # gaming & entertainment
        osu-lazer-bin
        tidal-hifi
        prismlauncher
        obs-studio

        # communication
        vesktop
        element-desktop

        # utilities
        proton-pass
        kdePackages.filelight
        qimgv
        qbittorrent-enhanced

        # development & creative
        godotPackages_4_6.godot
        blender
        bambu-studio

        # audio
        lsp-plugins
      ]);

      nixpkgs.config.allowUnfree = true;
    };
}
