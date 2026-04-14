{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      configFile = pkgs.writeText "tmux.conf" ''
        set -g @catppuccin_flavor "mocha"
        set -g @catppuccin_window_status_style "rounded"

        run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}#{E:@catppuccin_status_session}"
      '';
    in
    {
      packages.tmux = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.tmux;
        flags = {
          "-f" = toString configFile;
        };
      };
    };
}
