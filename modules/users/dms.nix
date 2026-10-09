{
  flake.modules.nixos.users-dms =
    {
      self,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      # Catppuccin from the DMS theme registry. Multi-variant theme; its dark
      # defaults are flavor=mocha, accent=mauve, so no variant selection is
      # needed. Bump rev+hash together.
      catppuccinTheme = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/AvengeMedia/dms-plugin-registry/1f289e9862a5f19c6d63a6931f313dad04577655/themes/catppuccin/theme.json";
        hash = "sha256-reELIdD8N+19CXo4RK8TSq0Yp/iXjblZO83M2GRVoRs=";
      };
      # Stable path (not a store path) so the seeded settings.json survives
      # theme bumps; DMS watches the file, so bumps apply live.
      themePath = "/etc/xdg/DankMaterialShell/themes/catppuccin/theme.json";

      # DMS has no system-wide defaults layer: it only reads
      # ~/.config/DankMaterialShell/settings.json, and treats a read-only file
      # as "don't persist GUI changes". So seed it once (ExecStartPre) and let
      # the GUI own it afterwards. Seeding also skips the first-launch wizard.
      settingsJson = (pkgs.formats.json { }).generate "dms-settings.json" {
        currentThemeCategory = "custom";
        currentThemeName = "custom";
        customThemeFile = themePath;
        # Papirus from users-desktop. DMS propagates this into the user's
        # gtk-3.0/4.0 settings.ini on apply, so it's the single source.
        iconThemeDark = "Papirus-Dark";
      };
      seedSettings = pkgs.writeShellScript "dms-seed-settings" ''
        dir="''${XDG_CONFIG_HOME:-$HOME/.config}/DankMaterialShell"
        [ -e "$dir/settings.json" ] && exit 0
        ${pkgs.coreutils}/bin/mkdir -p "$dir"
        ${pkgs.coreutils}/bin/install -m644 ${settingsJson} "$dir/settings.json"
      '';

      # DMS's keybind cheatsheet (Mod+Shift+/) only parses
      # ~/.config/niri/config.kdl; the wrapped niri runs off NIRI_CONFIG in the
      # store instead. Bridge with a stable /etc path included from the user
      # file. DMS also writes its own include lines into that file, so append
      # rather than own it.
      niriConfigInclude = "/etc/xdg/niri/config.kdl";
      seedNiriInclude = pkgs.writeShellScript "dms-seed-niri-include" ''
        f="''${XDG_CONFIG_HOME:-$HOME/.config}/niri/config.kdl"
        line='include "${niriConfigInclude}"'
        ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$f")"
        [ -e "$f" ] && ${pkgs.gnugrep}/bin/grep -qxF "$line" "$f" && exit 0
        echo "$line" >> "$f"
      '';
    in
    {
      # Runs under systemd so `nixos-rebuild switch` restarts it with niri;
      # a leftover shell from an older generation is unreachable via IPC,
      # leaving Mod+S dead until relogin. The nixpkgs module clears the unit's
      # PATH so it inherits the user manager's (niri imports the session env),
      # which DMS needs for the tools it shells out to.
      programs.dms-shell = {
        enable = true;
        package = self.packages.${system}.dms-shell;
      };

      systemd.user.services.dms.serviceConfig.ExecStartPre = [
        seedSettings
        seedNiriInclude
      ];

      environment.etc."xdg/niri/config.kdl".source = "${self.packages.${system}.niri}/niri-config.kdl";

      environment.etc."xdg/DankMaterialShell/themes/catppuccin/theme.json".source = catppuccinTheme;
    };
}
