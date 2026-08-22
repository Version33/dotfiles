{
  flake.modules.nixos.users-packages =
    {
      self,
      pkgs,
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
          lazygit
          herdr
          oh-my-pi
          bitwig-studio
          goofcord
          proton-drive
          feedback
          godot
          orca-slicer # nightly build for Bambu H2C support; bump via `nix run .#orca-nightly-update`
        ])
        ++ (with pkgs; [
          # Applications
          osu-lazer-bin
          tidal-hifi
          prismlauncher
          deadlock-mod-manager
          obs-studio
          synthesia
          element-desktop
          proton-pass
          kdePackages.filelight
          qimgv
          qbittorrent-enhanced
          blender
          lsp-plugins
          renoise # demo build; pass releasePath after purchase for full version
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
          pciutils
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
        ])
        ++ (with pkgs; [
          # Wine
          wineWow64Packages.staging
          winetricks
          wineWow64Packages.fonts
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
          upx
        ])
        ++ (with pkgs; [
          # Language servers
          markdown-oxide
        ]);

      programs.steam = {
        enable = true;

        # nixpkgs runs Steam under `bwrap --die-with-parent`. niri's spawn
        # double-forks and the intermediate exits immediately, so PDEATHSIG kills
        # the sandbox before Steam starts. Dropping the flag fixes every launch
        # path without a wrapper script or desktop-entry override.
        package = pkgs.steam.override {
          buildFHSEnv = args: pkgs.buildFHSEnv (args // { dieWithParent = false; });
        };
      };

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
