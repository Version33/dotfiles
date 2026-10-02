{
  flake.modules.nixos.users-desktop =
    {
      self,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      programs.niri = {
        enable = true;
        package = self.packages.${system}.niri;
      };

      # Runs under systemd so `nixos-rebuild switch` restarts it with niri;
      # a leftover daemon from an older generation is unreachable via IPC,
      # leaving Mod+S dead until relogin. The unit inherits the user manager's
      # PATH (niri imports the session env), which Noctalia needs for the
      # tools it shells out to.
      programs.noctalia = {
        enable = true;
        package = self.packages.${system}.noctalia;
        systemd.enable = true;
      };

      environment = {
        systemPackages = with pkgs; [
          catppuccin-cursors.mochaDark
          adw-gtk3
        ];

        sessionVariables = {
          XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
          XCURSOR_SIZE = "24";
          XCURSOR_PATH = lib.mkForce "${pkgs.catppuccin-cursors.mochaDark}/share/icons:~/.icons:~/.local/share/icons";
          GTK_THEME = "adw-gtk3-dark";
          NIXOS_OZONE_WL = "1";
        };

        # GTK only reads settings.ini from $XDG_CONFIG_DIRS (starts at
        # /etc/xdg, not bare /etc), hence etc/xdg here. gtk.css has no
        # system-wide equivalent — only read from per-user $XDG_CONFIG_HOME.
        etc = {
          "xdg/gtk-3.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=adw-gtk3-dark
            gtk-application-prefer-dark-theme=1
          '';
          "xdg/gtk-4.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=adw-gtk3-dark
            gtk-application-prefer-dark-theme=1
          '';
        };
      };

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd niri-session";
            user = "greeter";
          };
        };
      };
    };
}
