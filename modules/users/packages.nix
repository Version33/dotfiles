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
          atuin
          tealdeer
          superfile
          bitwig-studio
          ableton-live
          goofcord
          proton-drive
          feedback
          godot
          orca-slicer # nightly build for Bambu H2C support; bump via `nix flake update orca-nightly`
          hueforge # proprietary; bump via new AppImage + version in modules/packages/hueforge.nix
          osu-lazer-bin # override disables bwrap --die-with-parent so noctalia can launch it
        ])
        ++ (with pkgs; [
          # Applications
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
          openvpn
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
          cargo-seek
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
          ffmpeg-full # superset of `ffmpeg`; also pulled in by the screen recorders
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
          # Wayland / desktop integration
          at-spi2-atk # accessibility bus protocol + daemon
          qt6.qtwayland
          xdg-utils
          playerctl # MPRIS media player control
          psi-notify # resource-saturation alerts (unit enabled in services/services.nix)
          grim # screenshot capture
          slurp # region select
          swappy # screenshot annotation
          wl-screenrec # hardware-encoded screen recording
          wl-clipboard
          wl-clip-persist # keep clipboard after the source program exits
          cliphist # clipboard history
          wtype # xdotool type, for wayland
          wlrctl # misc wlroots protocol control
          gifsicle
          psmisc # fuser, killall, pstree
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

      programs = {
        steam = {
          enable = true;

          # niri's spawn double-forks; the intermediate exits immediately so
          # PDEATHSIG kills bwrap before Steam starts. Drop --die-with-parent.
          package = pkgs.steam.override {
            buildFHSEnv = args: pkgs.buildFHSEnv (args // { dieWithParent = false; });
          };
        };

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
