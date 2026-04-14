{
  flake.modules.nixos.cli-tools =
    { self, pkgs, ... }:
    {
      # Essential CLI utilities for everyday use
      environment.systemPackages =
        (with pkgs; [
          # file management
          p7zip
          ouch

          # search & navigation
          fzf
          skim
          zoxide
          fd
          ripgrep

          # file operations
          eza
          dust
          duf
          ncdu
          tre-command

          # system monitoring
          procs
          progress
          lsof

          # terminal
          tmux
          moreutils

          # info
          tealdeer
          macchina
          tokei
        ])
        ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
          yazi
          opencode
          ssh
          btop
        ]);
    };
}
