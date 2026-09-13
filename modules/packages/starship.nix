{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      theme,
      ...
    }:
    let
      # starship.toml styles reference these role names; the palette is
      # generated so the checked-in toml never hardcodes a scheme.
      paletteRoles = with theme.colors.withHashtag; {
        bg = base00;
        bg_alt = base01;
        surface = base02;
        dim = base03;
        fg_dim = base04;
        fg = base05;
        inherit
          red
          orange
          yellow
          green
          cyan
          blue
          magenta
          ;
        bright_blue = bright-blue; # Catppuccin's sapphire
        accent = "#${theme.accent}";
        accent2 = base0E;
        # Text on coloured segments: darkest bg (base24 base11, crust) for contrast.
        on_accent = theme.colors.withHashtag.base11 or base00;
      };
      paletteLines = lib.mapAttrsToList (role: hex: ''${role} = "${hex}"'') paletteRoles;
      configFile = pkgs.writeText "starship.toml" (
        # `palette = "theme"` MUST precede every `[table]` header — TOML
        # scopes bare keys to the last-opened table, so this can't just be
        # appended after the checked-in file's `[cmd_duration]` etc.
        ''
          palette = "theme"

        ''
        + builtins.readFile ./starship.toml
        + ''

          [palettes.theme]
          ${lib.concatStringsSep "\n" paletteLines}
        ''
      );
    in
    {
      packages.starship =
        (inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.starship;
          # envDefault, so an explicit STARSHIP_CONFIG still overrides this.
          # Covers direct invocations (nix run, yazi's prompt plugin, …).
          envDefault = {
            STARSHIP_CONFIG = configFile;
          };
        })
        # `starship init` embeds current_exe(), i.e. the UNWRAPPED binary, in
        # the generated prompt function — the wrapper env never reaches those
        # prompt-time calls. Shell integrations must export this themselves.
        // {
          inherit configFile;
        };
    };
}
