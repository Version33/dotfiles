{
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, self', ... }:
    let
      starship = self'.packages.starship;
      # Compact greeting: small distro logo, one-line separator, few modules.
      fastfetchConf = pkgs.writeText "fastfetch.jsonc" ''
        {
          "logo": { "type": "small", "padding": { "top": 1 } },
          "display": { "separator": " " },
          "modules": [
            "os",
            "kernel",
            "wm",
            "shell",
            "uptime",
            "memory",
            "break",
            "colors"
          ]
        }
      '';
      fishConf =
        pkgs.writeText "config.fish" # fish
          ''

            # The wrapper passes this file via -C for *every* fish invocation,
            # including scripts — keep prompt/alias setup interactive-only.
            if status is-interactive
              # fastfetch greeting (function overrides the default $fish_greeting)
              function fish_greeting
                ${lib.getExe pkgs.fastfetch} --config ${fastfetchConf}
              end
              fish_vi_key_bindings

              # starship prompt. The init script embeds the UNWRAPPED binary
              # path (current_exe), so the wrapper's env never reaches the
              # per-prompt calls — export the wrapper's config path here.
              set -gx STARSHIP_CONFIG ${starship.configFile}
              ${lib.getExe starship} init fish | source

              # direnv hook
              if type -q direnv
                direnv hook fish | source
              end

              # zoxide
              ${lib.getExe pkgs.zoxide} init fish | source

              # aliases
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
                  nixfmt $f
                end
              end

              function reboot-to-windows
                set -l id (sudo efibootmgr | string match -rg '^Boot([0-9A-Fa-f]{4})\*?\s+Windows Boot Manager')[1]
                if test -z "$id"
                  echo "reboot-to-windows: no \"Windows Boot Manager\" entry found in efibootmgr output" >&2
                  return 1
                end
                sudo efibootmgr --bootnext $id
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
            starship
            pkgs.zoxide
            pkgs.eza
            pkgs.fastfetch
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
