{
  flake.modules.nixos.users-dms =
    { pkgs, ... }:
    let
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
      };
      seedSettings = pkgs.writeShellScript "dms-seed-settings" ''
        dir="''${XDG_CONFIG_HOME:-$HOME/.config}/DankMaterialShell"
        [ -e "$dir/settings.json" ] && exit 0
        ${pkgs.coreutils}/bin/mkdir -p "$dir"
        ${pkgs.coreutils}/bin/install -m644 ${settingsJson} "$dir/settings.json"
      '';
    in
    {
      # Runs under systemd so `nixos-rebuild switch` restarts it with niri;
      # a leftover shell from an older generation is unreachable via IPC,
      # leaving Mod+S dead until relogin. The nixpkgs module clears the unit's
      # PATH so it inherits the user manager's (niri imports the session env),
      # which DMS needs for the tools it shells out to.
      programs.dms-shell.enable = true;

      systemd.user.services.dms.serviceConfig.ExecStartPre = seedSettings;

      environment.etc."xdg/DankMaterialShell/themes/catppuccin/theme.json".source = catppuccinTheme;
    };
}
