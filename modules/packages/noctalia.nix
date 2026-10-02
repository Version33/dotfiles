{
  perSystem =
    { pkgs, ... }:
    let
      configToml = (pkgs.formats.toml { }).generate "noctalia-config.toml" {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };
      };
      # v5 reads every *.toml under $NOCTALIA_CONFIG_HOME/noctalia/ (falls back
      # to ~/.config). GUI changes land in ~/.local/state/noctalia/settings.toml
      # and layer on top, so a read-only store dir is fine.
      configHome = pkgs.runCommand "noctalia-config-home" { } ''
        install -Dm444 ${configToml} $out/noctalia/config.toml
      '';
    in
    {
      packages.noctalia = pkgs.symlinkJoin {
        inherit (pkgs.noctalia) name meta;
        paths = [ pkgs.noctalia ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/noctalia --set NOCTALIA_CONFIG_HOME ${configHome}
        '';
      };
    };
}
