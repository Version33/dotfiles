{
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      starshipConf = ./starship.toml;
      fishConf =
        pkgs.writeText "config.fish" # fish
          ''

            # The wrapper passes this file via -C for *every* fish invocation,
            # including scripts — keep prompt/alias setup interactive-only.
            if status is-interactive
              set -g fish_greeting
              fish_vi_key_bindings

              # starship prompt
              set -gx STARSHIP_CONFIG ${starshipConf}
              ${lib.getExe pkgs.starship} init fish | source

              # direnv hook
              if type -q direnv
                direnv hook fish | source
              end

              # zoxide
              fish_add_path ${pkgs.zoxide}/bin
              ${lib.getExe pkgs.zoxide} init fish | source

              # aliases
              fish_add_path ${pkgs.eza}/bin
              alias ls "eza --icons=auto --color=auto --group-directories-first"
              alias ll "eza -la --icons=auto --git --header --time-style=relative --group-directories-first"
              alias la "eza -a --icons=auto --group-directories-first"
              alias lt "eza --tree --icons=auto --level=2"
              alias v "nvim"
              alias yz "yazi"
              alias g "git"
              alias lg "lazygit"
              alias conf "z ~/.config"
              alias nixos "z /etc/nixos"
              alias nswitch "sudo nixos-rebuild switch --flake /etc/nixos#k0or"
              alias nsgc "sudo nix-store --gc"
              alias ngc "sudo nix-collect-garbage -d"
              alias ngc7 "sudo nix-collect-garbage --delete-older-than 7d"
              alias ngc14 "sudo nix-collect-garbage --delete-older-than 14d"

              function format-nix
                for f in *.nix
                  sudo nixfmt $f
                end
              end

              function reboot-to-windows
                sudo efibootmgr --bootnext 0000
                sudo systemctl reboot
              end
            end
          '';
    in
    {
      packages.fish =
        (inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.fish;
          runtimePkgs = [
            pkgs.starship
            pkgs.zoxide
            pkgs.eza
          ];
          flags = {
            "-C" = "source ${fishConf}";
          };
        })
        // {
          shellPath = "/bin/fish";
        };
    };

  flake.modules.nixos.wrapped-fish =
    { self, pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
