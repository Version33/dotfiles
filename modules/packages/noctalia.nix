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
      # Noctalia only takes a scheme *name* (it regenerates colors.json from it
      # on every start), so map tinted families onto its bundled schemes.
      bundled = {
        catppuccin = "Catppuccin";
        gruvbox = "Gruvbox";
        tokyo-night = "Tokyo-Night";
        nord = "Nord";
        dracula = "Dracula";
        rose-pine = "Rosepine";
        kanagawa = "Kanagawa";
        ayu = "Ayu";
        eldritch = "Eldritch";
      };
      predefinedScheme =
        if theme.noctaliaScheme != null then
          theme.noctaliaScheme
        else
          theme.pick bundled "Noctalia-default";
    in
    {
      packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs;
        settings = lib.recursiveUpdate (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings {
          colorSchemes = {
            inherit predefinedScheme;
            darkMode = theme.dark;
          };
          wallpaper.solidColor = "#${theme.colors.base00}";
        };
        package = pkgs.noctalia-shell.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            # Upstream demotes session actions below app results (`score - 1`)
            substituteInPlace Modules/Panels/Launcher/Providers/SessionProvider.qml \
              --replace-fail '"_score": score - 1,' '"_score": score + 1,' \
              --replace-fail '"keywords": ["hibernate", "disk"]' '"keywords": ["hibernate"]'

            # Ship the community schemes (Cyberpunk, Aura, ...) as built-ins
            # instead of relying on the in-app downloader writing to ~/.config.
            for d in ${inputs.noctalia-colorschemes}/*/; do
              cp -R --no-preserve=mode "$d" Assets/ColorScheme/
            done
          '';
        });
      };
    };
}
