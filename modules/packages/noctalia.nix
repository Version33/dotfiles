{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      theme,
      ...
    }:
    let
      # Noctalia palettes compiled into the binary (see `[theme].builtin`),
      # keyed by the tinted family prefix they correspond to.
      builtin = {
        catppuccin = "Catppuccin";
        gruvbox = "Gruvbox";
        tokyo-night = "Tokyo-Night";
        nord = "Nord";
        dracula = "Dracula";
        rose-pine = "Rosé Pine";
        kanagawa = "Kanagawa";
        ayu = "Ayu";
        eldritch = "Eldritch";
      };
      # Same-named community palette if there is one, else nearest builtin.
      # Community palettes ship in the config dir as `custom` palettes so no
      # network fetch (api.noctalia.dev) is needed at startup.
      palette =
        if theme.noctaliaScheme != null then
          {
            source = "custom";
            custom_palette = theme.noctaliaScheme;
          }
        else
          {
            source = "builtin";
            builtin = theme.pick builtin "Noctalia";
          };
      configToml = (pkgs.formats.toml { }).generate "noctalia-config.toml" {
        theme = {
          mode = if theme.dark then "dark" else "light";
        }
        // palette;
      };
      # v5 reads every *.toml under $NOCTALIA_CONFIG_HOME/noctalia/ (falls back
      # to ~/.config). GUI changes land in ~/.local/state/noctalia/settings.toml
      # and layer on top, so a read-only store dir is fine.
      configHome = pkgs.runCommand "noctalia-config-home" { } ''
        install -Dm444 ${configToml} $out/noctalia/config.toml
        mkdir -p $out/noctalia/palettes
        for d in ${inputs.noctalia-colorschemes}/*/; do
          n=$(basename "$d")
          install -m444 "$d/$n.json" "$out/noctalia/palettes/$n.json"
        done
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
