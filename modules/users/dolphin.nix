# Dolphin themed from the global colour scheme (modules/theme.nix). Runs
# outside Plasma (niri), so theming goes through /etc/xdg/kdeglobals (KConfig
# cascade), not Plasma's UI.
{
  flake.modules.nixos.users-dolphin =
    {
      pkgs,
      lib,
      theme,
      ...
    }:
    let
      c = theme.colors;

      # kdeglobals wants "r,g,b" decimal triplets.
      rgb =
        hex:
        let
          byte = pos: lib.fromHexString (builtins.substring pos 2 hex);
        in
        "${toString (byte 0)},${toString (byte 2)},${toString (byte 4)}";

      # One [Colors:*] group's worth of standard KColorScheme keys.
      colorGroup =
        {
          bg,
          alt ? bg,
          fg,
        }:
        ''
          BackgroundNormal=${rgb bg}
          BackgroundAlternate=${rgb alt}
          ForegroundNormal=${rgb fg}
          ForegroundInactive=${rgb c.base04}
          ForegroundActive=${rgb c.base0C}
          ForegroundLink=${rgb c.base0D}
          ForegroundVisited=${rgb c.base0E}
          ForegroundNegative=${rgb c.base08}
          ForegroundNeutral=${rgb c.base09}
          ForegroundPositive=${rgb c.base0B}
          DecorationFocus=${rgb theme.accent}
          DecorationHover=${rgb theme.accent}
        '';
    in
    {
      environment.systemPackages = with pkgs; [
        kdePackages.dolphin
        kdePackages.kio-extras # thumbnails, archive/network protocols
        kdePackages.ark # archive tool + Extract/Compress context menus
        kdePackages.ffmpegthumbs # video thumbnails
        kdePackages.kdegraphics-thumbnailers # PDF/RAW thumbnails
        kdePackages.kimageformats # webp/avif/heif/jxl previews
        kdePackages.qtimageformats # extra Qt image formats (tiff, webp)
        kdePackages.qtsvg # SVG icon rendering
        kdePackages.breeze-icons # icon fallback
        papirus-icon-theme
      ];

      # plasma-integration lets Qt/KDE apps read kdeglobals outside Plasma;
      # without it Qt falls back to its default light palette.
      qt = {
        enable = true;
        platformTheme = "kde";
        style = "breeze";
      };

      # Hand-rolled kdeglobals (structure copied from
      # kdePackages.breeze's BreezeDark.colors) instead of a fetched
      # colour-scheme package, so it follows theme.scheme automatically.
      # Complementary mirrors Window (Breeze's own schemes do the same).
      environment.etc."xdg/kdeglobals".text = ''
        [Colors:View]
        ${colorGroup {
          bg = c.base00;
          alt = c.base01;
          fg = c.base05;
        }}
        [Colors:Window]
        ${colorGroup {
          bg = c.base01;
          alt = c.base02;
          fg = c.base05;
        }}
        [Colors:Button]
        ${colorGroup {
          bg = c.base02;
          fg = c.base05;
        }}
        [Colors:Selection]
        ${colorGroup {
          bg = theme.accent;
          fg = c.base00;
        }}
        [Colors:Tooltip]
        ${colorGroup {
          bg = c.base01;
          fg = c.base05;
        }}
        [Colors:Complementary]
        ${colorGroup {
          bg = c.base01;
          alt = c.base02;
          fg = c.base05;
        }}
        [Colors:Header]
        ${colorGroup {
          bg = c.base01;
          fg = c.base05;
        }}

        [General]
        ColorScheme=${theme.scheme}
        Name=${c.scheme-name}

        [Icons]
        Theme=${if theme.dark then "Papirus-Dark" else "Papirus-Light"}

        [KDE]
        contrast=4

        [WM]
        activeBackground=${rgb c.base01}
        activeForeground=${rgb c.base05}
        inactiveBackground=${rgb c.base00}
        inactiveForeground=${rgb c.base04}
      '';

      # Default file manager for anything that opens directories
      xdg.mime.defaultApplications = {
        "inode/directory" = "org.kde.dolphin.desktop";
        # Archives open in Ark
        "application/zip" = "org.kde.ark.desktop";
        "application/x-tar" = "org.kde.ark.desktop";
        "application/x-compressed-tar" = "org.kde.ark.desktop";
        "application/x-bzip-compressed-tar" = "org.kde.ark.desktop";
        "application/x-xz-compressed-tar" = "org.kde.ark.desktop";
        "application/x-zstd-compressed-tar" = "org.kde.ark.desktop";
        "application/x-7z-compressed" = "org.kde.ark.desktop";
        "application/vnd.rar" = "org.kde.ark.desktop";
        "application/gzip" = "org.kde.ark.desktop";
      };
    };
}
