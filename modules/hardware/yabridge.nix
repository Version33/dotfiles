{
  flake.modules.nixos.yabridge =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        yabridge
        yabridgectl
        # Wine matching the version yabridge is built against
        # (pkgs.wineWow64Packages.yabridge, currently 9.21), locked to the
        # dedicated plugin prefix. Use this — not plain `wine` — to run
        # plugin installers (Kilohearts Installer, Cableguys setups, ...).
        # Mixing system wine and yabridge's wine in one prefix causes
        # "wine client error: version mismatch" when loading plugins.
        (writeShellScriptBin "yabridge-wine" ''
          export WINEPREFIX="''${WINEPREFIX:-$HOME/.wine-yabridge}"
          exec ${wineWow64Packages.yabridge}/bin/wine "$@"
        '')
      ];
    };
}
