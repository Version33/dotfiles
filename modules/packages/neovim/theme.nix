{
  flake.modules.neovim.theme =
    { theme, lib, ... }:
    let
      inherit (lib) hasInfix elemAt splitString;
      scheme = theme.scheme;
      variant = list: default: lib.findFirst (v: hasInfix v scheme) default list;

      # Native nvf colorschemes where they exist; base16 plugin otherwise.
      native = {
        catppuccin = {
          name = "catppuccin";
          style = elemAt (splitString "-" scheme) 1;
        };
        gruvbox = {
          name = "gruvbox";
          style = if theme.dark then "dark" else "light";
        };
        tokyo-night = {
          name = "tokyonight";
          style = variant [ "day" "storm" "moon" ] "night";
        };
        rose-pine = {
          name = "rose-pine";
          style = variant [ "moon" "dawn" ] "main";
        };
        nord.name = "nord";
        dracula.name = "dracula";
      };
      nvfTheme = theme.pick native {
        name = "base16";
        base16-colors = lib.getAttrs (map (n: "base0${n}") (
          lib.stringToCharacters "0123456789ABCDEF"
        )) theme.colors.withHashtag;
      };
    in
    {
      config.vim.theme = {
        enable = true;
        transparent = false;
      }
      // nvfTheme;
    };
}
