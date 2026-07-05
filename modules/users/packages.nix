{
  flake.modules.nixos.users-packages =
    {
      self,
      pkgs,
      inputs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      environment.systemPackages =
        # Wrapped shared packages
        (with self.packages.${system}; [
          kitty
          yazi
          btop
          tmux # TODO: Remove - replaced by herdr
          lazygit
          opencode # TODO: Remove - replaced by pi
          herdr
          pi
          steam-launcher
          steam-desktop-item
        ])
        ++ (with pkgs; [
          # Applications
          osu-lazer-bin
          tidal-hifi
          prismlauncher
          obs-studio
          synthesia
          goofcord
          element-desktop
          proton-pass
          kdePackages.filelight
          qimgv
          qbittorrent-enhanced
          godotPackages_4_6.godot
          blender
          bambu-studio
          lsp-plugins
        ])
        ++ (with pkgs; [
          # CLI tools
          p7zip
          ouch
          fzf
          skim
          zoxide
          fd
          ripgrep
          eza
          dust
          duf
          ncdu
          tre-command
          procs
          progress
          lsof
          moreutils
          tealdeer
          macchina
          tokei
          claude-code
        ])
        ++ (with pkgs; [
          # Fun tools
          cmatrix
          pipes-rs
          rsclock
          cava
          figlet
        ])
        ++ (with pkgs; [
          # Git tools
          delta
          gh
          bat
          git-ignore
          gitleaks
          git-secrets
        ])
        ++ (with pkgs; [
          # Hardware tools
          gparted
          ntfs3g
          efibootmgr
        ])
        ++ (with pkgs; [
          # Media tools
          imagemagick
          imv
          ffmpeg
          yt-dlp
          chafa
          viu
          hexyl
          mdcat
          pandoc
          tree-sitter
        ])
        ++ (with pkgs; [
          # Network tools
          gping
          rewrk
          sshfs
          upx
        ])
        ++ (with pkgs; [
          # Wine
          wineWow64Packages.staging
          winetricks
          wine64Packages.fonts
        ])
        ++ (with pkgs; [
          # Compilers & build tools
          comma
          mold
          gcc
          clang
          lld
          lldb
          musl
          trunk
        ])
        ++ (with pkgs; [
          # Language servers
          markdown-oxide
        ])
        ++ [
          # Audio
          inputs.audio-nix.packages.${system}.bitwig-studio6-latest
        ];

      programs.steam.enable = true;

      programs.gamescope.enable = true;

      programs.gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
          };
        };
      };
    };
}
