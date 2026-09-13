# Global colour scheme: set `theme.scheme`, rebuild, everything follows.
#
# Slugs resolve against github:tinted-theming/schemes (base24/ then base16/,
# e.g. catppuccin-mocha, gruvbox-dark-hard, tokyo-night-storm) and then
# github:noctalia-dev/noctalia-colorschemes (<Name>/<Name>.json lowercased with
# dashes, e.g. cyberpunk, ayu-blue; `-light` suffix picks the light variant).
# A Noctalia accent variant of a tinted scheme (catppuccin-mocha-lavender) uses
# the tinted palette and only takes the accent from Noctalia.
{
  inputs,
  config,
  lib,
  ...
}:
let
  slug = config.theme.scheme;

  tintedFile =
    s:
    lib.findFirst builtins.pathExists null [
      "${inputs.tt-schemes}/base24/${s}.yaml"
      "${inputs.tt-schemes}/base16/${s}.yaml"
    ];
  # Exact slug first, then shorter prefixes for Noctalia accent variants.
  tintedSlug =
    let
      parts = lib.splitString "-" slug;
      prefixes = map (n: lib.concatStringsSep "-" (lib.take n parts)) (
        lib.reverseList (lib.range 1 (lib.length parts))
      );
    in
    lib.findFirst (p: tintedFile p != null) null prefixes;
  tinted = if tintedSlug == null then null else tintedFile tintedSlug;

  yamlField =
    key: default:
    let
      line = lib.findFirst (lib.hasPrefix "${key}:") null (
        lib.splitString "\n" (builtins.readFile tinted)
      );
    in
    if line == null then
      default
    else
      lib.removeSuffix "\"" (lib.removePrefix "\"" (lib.trim (lib.removePrefix "${key}:" line)));

  noctaliaLight = lib.hasSuffix "-light" slug;
  noctaliaName =
    let
      wanted = lib.removeSuffix "-light" (lib.removeSuffix "-dark" slug);
      dirs = lib.filterAttrs (_: t: t == "directory") (builtins.readDir inputs.noctalia-colorschemes);
    in
    lib.findFirst (n: lib.toLower (lib.replaceStrings [ " " ] [ "-" ] n) == wanted) null (
      lib.attrNames dirs
    );
  noctalia =
    let
      json = lib.importJSON "${inputs.noctalia-colorschemes}/${noctaliaName}/${noctaliaName}.json";
      variant = if noctaliaLight then "light" else "dark";
      v = json.${variant} or (throw "theme.scheme: '${noctaliaName}' has no ${variant} variant");
      t = v.terminal or (throw "theme.scheme: '${noctaliaName}' has no terminal colours");
      hex = lib.removePrefix "#";
      # Per-channel average; Noctalia has no orange slot.
      blend =
        a: b:
        lib.concatMapStrings
          (
            pos:
            lib.toLower (
              lib.fixedWidthString 2 "0" (
                lib.toHexString (
                  (lib.fromHexString (builtins.substring pos 2 a) + lib.fromHexString (builtins.substring pos 2 b))
                  / 2
                )
              )
            )
          )
          [
            0
            2
            4
          ];
    in
    {
      inherit variant;
      accent = hex v.mPrimary;
      attrs = {
        scheme = noctaliaName;
        inherit slug;
        author = "noctalia-dev/noctalia-colorschemes";
        base00 = hex t.background;
        base01 = hex v.mSurfaceVariant;
        base02 = hex t.bright.black;
        base03 = hex v.mOnSurfaceVariant;
        base04 = hex t.normal.white;
        base05 = hex t.foreground;
        base06 = hex t.bright.white;
        base07 = hex t.bright.white;
        base08 = hex t.normal.red;
        base09 = blend (hex t.normal.red) (hex t.normal.yellow);
        base0A = hex t.normal.yellow;
        base0B = hex t.normal.green;
        base0C = hex t.normal.cyan;
        base0D = hex t.normal.blue;
        base0E = hex t.normal.magenta;
        base0F = hex v.mError;
        base10 = hex v.mSurface;
        base11 = hex v.mShadow;
        base12 = hex t.bright.red;
        base13 = hex t.bright.yellow;
        base14 = hex t.bright.green;
        base15 = hex t.bright.cyan;
        base16 = hex t.bright.blue;
        base17 = hex t.bright.magenta;
      };
    };

  fromNoctalia =
    if tintedSlug == slug then
      false
    else if noctaliaName != null then
      true
    else
      throw "theme.scheme: '${slug}' is neither a tinted-theming slug nor a noctalia community scheme";

  polarity = if fromNoctalia then noctalia.variant else yamlField "variant" "dark";

  # Needs pkgs for template rendering, so instantiated per consumer.
  mkTheme =
    pkgs:
    let
      colors = (pkgs.callPackage inputs.base16.lib { }).mkSchemeAttrs (
        if tinted != null then tinted else noctalia.attrs
      );
    in
    {
      scheme = slug;
      inherit polarity;
      dark = polarity == "dark";
      system = if tinted != null then yamlField "system" "base16" else "base24";

      # base16.nix scheme attrs: baseXX (no '#'), `withHashtag`, mnemonics
      # (red, bright-blue, ...). Callable to render a tinted template:
      #   colors inputs.tinted-yazi
      #   colors { template = readFile ".../kitty-${system}.mustache"; extension = ".conf"; }
      # (tinted-terminal's config.yaml trips base16.nix's YAML parser, hence the second form.)
      inherit colors;

      # No accent slot in base16; base0D by convention, Noctalia names its own.
      accent = if fromNoctalia then noctalia.accent else colors.base0D;

      # Exact Noctalia scheme name when the palette or accent came from there.
      noctaliaScheme = if fromNoctalia then noctaliaName else null;

      # Terminal order (black..white, then bright), for console/fzf/fish.
      ansi = with colors; [
        base00
        red
        green
        yellow
        blue
        magenta
        cyan
        base05
        base03
        bright-red
        bright-green
        bright-yellow
        bright-blue
        bright-magenta
        bright-cyan
        base07
      ];

      cursor =
        if lib.hasPrefix "catppuccin-" slug then
          let
            # catppuccin-mocha -> mochaDark|mochaLight; catppuccin-mocha-lavender -> mochaLavender
            parts = lib.splitString "-" (lib.removePrefix "catppuccin-" slug);
            flavor = lib.head parts;
            accent = lib.toSentenceCase (lib.elemAt parts 1);
            variant =
              if lib.length parts > 1 && pkgs.catppuccin-cursors ? "${flavor}${accent}" then
                accent
              else if polarity == "dark" then
                "Dark"
              else
                "Light";
          in
          {
            package = pkgs.catppuccin-cursors."${flavor}${variant}";
            name = "catppuccin-${flavor}-${lib.toLower variant}-cursors";
          }
        else
          {
            package = pkgs.bibata-cursors;
            name = if polarity == "dark" then "Bibata-Modern-Classic" else "Bibata-Modern-Ice";
          };
    };
in
{
  options.theme.scheme = lib.mkOption {
    type = lib.types.str;
    description = "Colour scheme slug (tinted-theming or Noctalia community scheme).";
  };

  config = {
    theme.scheme = "catppuccin-mocha-lavender";

    flake-file.inputs = {
      base16.url = "github:SenchoPens/base16.nix";
      tt-schemes = {
        url = "github:tinted-theming/schemes";
        flake = false;
      };
      tinted-terminal = {
        url = "github:tinted-theming/tinted-terminal";
        flake = false;
      };
      tinted-yazi = {
        url = "github:tinted-theming/tinted-yazi";
        flake = false;
      };
      tinted-lazygit = {
        url = "github:tinted-theming/tinted-lazygit";
        flake = false;
      };
      noctalia-colorschemes = {
        url = "github:noctalia-dev/noctalia-colorschemes";
        flake = false;
      };
    };

    perSystem =
      { pkgs, ... }:
      {
        _module.args.theme = mkTheme pkgs;
      };

    flake.modules.nixos.theme =
      { pkgs, ... }:
      {
        _module.args.theme = mkTheme pkgs;
      };
  };
}
