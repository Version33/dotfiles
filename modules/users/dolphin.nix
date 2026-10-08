# Dolphin outside Plasma (niri). Theming is left to DMS's matugen templates.
{
  flake.modules.nixos.users-dolphin =
    { pkgs, ... }:
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
      ];

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
