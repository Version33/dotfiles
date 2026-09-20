# Global colour scheme: set `theme.scheme`, rebuild, everything follows.
#
# Slugs resolve against github:tinted-theming/schemes (base24/ then base16/,
# e.g. catppuccin-mocha, gruvbox-dark-hard, tokyo-night-storm), else
# github:noctalia-dev/noctalia-colorschemes (<Name>/<Name>.json lowercased with
# dashes, e.g. cyberpunk, ayu-blue; `-light` suffix picks the light variant).
# catppuccin-<flavor>-<accent> uses the tinted palette with Noctalia's accent.
{
  inputs,
  config,
  lib,
  ...
}:
let
  tintedFile =
    s:
    lib.findFirst builtins.pathExists null [
      "${inputs.tt-schemes}/base24/${s}.yaml"
      "${inputs.tt-schemes}/base16/${s}.yaml"
    ];
  noctaliaDirs = lib.attrNames (
    lib.filterAttrs (n: t: t == "directory" && !lib.hasPrefix "." n) (
      builtins.readDir inputs.noctalia-colorschemes
    )
  );
  noctaliaSlug = n: lib.toLower (lib.replaceStrings [ " " ] [ "-" ] n);

  # Slug -> where its palette comes from (tinted YAML file or Noctalia attrs).
  resolve = slug: rec {
    parts = lib.splitString "-" slug;
    # Only Catppuccin has Noctalia accent variants of a tinted palette.
    tintedSlug = lib.findFirst (s: tintedFile s != null) null (
      [ slug ]
      ++ lib.optional (lib.hasPrefix "catppuccin-" slug) (lib.concatStringsSep "-" (lib.take 2 parts))
    );
    tinted = if tintedSlug == null then null else tintedFile tintedSlug;

    noctaliaLight = lib.hasSuffix "-light" slug;
    noctaliaName =
      let
        find = wanted: lib.findFirst (n: noctaliaSlug n == wanted) null noctaliaDirs;
        exact = find slug;
      in
      if exact != null then exact else find (lib.removeSuffix "-light" (lib.removeSuffix "-dark" slug));
    noctalia =
      if noctaliaName == null then
        throw "theme.scheme: '${slug}' is not a tinted-theming slug or Noctalia community scheme (see `just themes`)"
      else
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
          accent = hex v.mPrimary;
          attrs = {
            scheme = noctaliaName;
            inherit slug variant;
            system = "base24";
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
  };

  # Longest table key that prefixes the slug, else default; for per-app
  # family tables ({ catppuccin = …; catppuccin-latte = …; }).
  pick =
    slug: table: default:
    let
      keys = lib.filter (k: lib.hasPrefix k slug) (lib.attrNames table);
      longest = lib.foldl' (a: b: if lib.stringLength b > lib.stringLength a then b else a) "" keys;
    in
    if keys == [ ] then default else table.${longest};

  # Needs pkgs for template rendering, so instantiated per consumer.
  mkTheme =
    pkgs: slug:
    let
      inherit (resolve slug)
        tinted
        tintedSlug
        noctalia
        noctaliaName
        ;
      # base16.nix's pure YAML parser trips on comment lines inside `palette:`,
      # trailing `# comments` after values, and `|` block scalars (dracula,
      # alucard, ascendancy). Only flat `key: value` lines carry data we use,
      # so drop everything else. writeTextDir keeps the basename, which
      # base16.nix turns into `slug`.
      sanitized =
        let
          keep = l: l != "" && !lib.hasPrefix "#" (lib.trim l) && !lib.hasSuffix "|" l;
          # Everything after `key: "value"`; block-scalar bodies are indented
          # under a `|` line and have no `key:`, so they fall out as well.
          strip =
            l:
            let
              m = builtins.match ''([^:]+: *("[^"]*"|[^"#]*[^"# ])) *(#.*)?'' l;
            in
            if m == null then l else lib.head m;
          lines = lib.filter keep (lib.splitString "\n" (builtins.readFile tinted));
          text = lib.concatMapStrings (l: strip l + "\n") (lib.filter (lib.hasInfix ":") lines);
        in
        "${pkgs.writeTextDir "${tintedSlug}.yaml" text}/${tintedSlug}.yaml";
      base = (pkgs.callPackage inputs.base16.lib { }).mkSchemeAttrs (
        if tinted != null then sanitized else noctalia.attrs
      );
      # No accent slot in base16; base0D by convention, Noctalia names its own.
      accent = lib.toLower (if tintedSlug == slug then base.base0D else noctalia.accent);
      # tinted YAML `variant:` (unset in a few old base16 files) or Noctalia's.
      polarity = if base.variant == "light" then "light" else "dark";
    in
    {
      scheme = slug;
      inherit polarity;
      inherit (base) system;
      pick = pick slug;
      dark = polarity == "dark";

      # base16.nix scheme attrs plus `accent`: baseXX (no '#'), `withHashtag`,
      # mnemonics (red, bright-blue, ...). Callable to render a tinted template:
      #   colors inputs.tinted-yazi
      #   colors { template = readFile ".../kitty-${system}.mustache"; extension = ".conf"; }
      # (tinted-terminal's config.yaml trips base16.nix's YAML parser, hence the second form.)
      colors = base // {
        inherit accent;
        withHashtag = base.withHashtag // {
          accent = "#${accent}";
        };
      };

      # Same-named Noctalia community scheme, if any.
      noctaliaScheme = noctaliaName;

      # Terminal order (black..white, then bright), for console/fzf/fish.
      ansi = with base; [
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

      # Always Catppuccin cursors (the shape is the point); flavour/accent
      # from a Catppuccin scheme, else mocha/latte by polarity.
      cursor =
        let
          parts = lib.optionals (lib.hasPrefix "catppuccin-" slug) (
            lib.splitString "-" (lib.removePrefix "catppuccin-" slug)
          );
          flavor = if parts == [ ] then (if polarity == "dark" then "mocha" else "latte") else lib.head parts;
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
        };
    };
in
{
  options.theme.scheme = lib.mkOption {
    type = lib.types.str;
    default = "catppuccin-mocha-lavender";
    description = "Color scheme slug (tinted-theming or Noctalia community scheme).";
  };

  config = {
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
      let
        allSlugs =
          lib.unique (
            lib.concatMap
              (
                sys:
                map (lib.removeSuffix ".yaml") (
                  lib.filter (lib.hasSuffix ".yaml") (lib.attrNames (builtins.readDir "${inputs.tt-schemes}/${sys}"))
                )
              )
              [
                "base24"
                "base16"
              ]
          )
          ++ lib.concatMap (
            n:
            [ (noctaliaSlug n) ]
            ++ lib.optional (
              lib.importJSON "${inputs.noctalia-colorschemes}/${n}/${n}.json" ? light
            ) "${noctaliaSlug n}-light"
          ) noctaliaDirs;
        # Forces every derived field so an upstream shape change in either
        # scheme repo fails `nix flake check`, not the next rebuild.
        probe =
          slug:
          let
            t = mkTheme pkgs slug;
          in
          builtins.deepSeq {
            inherit (t) polarity system ansi;
            inherit (t.colors) accent base00 base0D;
            cursor = t.cursor.name;
          } "${slug} ${t.polarity} ${t.system} #${t.colors.accent}\n";
      in
      {
        _module.args.theme = mkTheme pkgs config.theme.scheme;
        checks.themes = pkgs.writeText "themes" (lib.concatMapStrings probe allSlugs);
      };

    flake.modules.nixos.theme =
      { pkgs, ... }:
      {
        _module.args.theme = mkTheme pkgs config.theme.scheme;
      };
  };
}
