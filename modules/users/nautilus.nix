# GTK file manager so it picks up adw-gtk3 + DMS's matugen gtk.css for free.
{
  flake.modules.nixos.users-nautilus =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nautilus
        file-roller # archive tool + Extract/Compress context menus
        ffmpegthumbnailer # video thumbnails
      ];

      services.gvfs.enable = true; # trash, MTP, network shares

      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };

      # Default file manager for anything that opens directories
      xdg.mime.defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
        # Archives open in File Roller
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-bzip-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-xz-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-zstd-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/vnd.rar" = "org.gnome.FileRoller.desktop";
        "application/gzip" = "org.gnome.FileRoller.desktop";
      };
    };
}
