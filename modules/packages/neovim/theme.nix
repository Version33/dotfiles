{
  flake.modules.neovim.theme =
    { theme, lib, ... }:
    let
      inherit (lib) hasPrefix hasInfix removePrefix;
      scheme = theme.scheme;

      # Native nvf colorschemes where they exist; base16 plugin otherwise.
      nvfTheme =
        if hasPrefix "catppuccin-" scheme then
          {
            name = "catppuccin";
            # accent variants ("catppuccin-mocha-lavender") -> "mocha"
            style = lib.head (lib.splitString "-" (removePrefix "catppuccin-" scheme));
          }
        else if hasPrefix "gruvbox" scheme then
          {
            name = "gruvbox";
            style = if hasInfix "light" scheme then "light" else "dark";
          }
        else if hasPrefix "tokyo-night" scheme then
          {
            name = "tokyonight";
            style =
              if hasInfix "day" scheme then
                "day"
              else if hasInfix "storm" scheme then
                "storm"
              else if hasInfix "moon" scheme then
                "moon"
              else
                "night";
          }
        else if hasPrefix "rose-pine" scheme then
          {
            name = "rose-pine";
            style =
              if hasInfix "moon" scheme then
                "moon"
              else if hasInfix "dawn" scheme then
                "dawn"
              else
                "main";
          }
        else if hasPrefix "nord" scheme then
          { name = "nord"; }
        else if hasPrefix "dracula" scheme then
          { name = "dracula"; }
        else
          {
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
