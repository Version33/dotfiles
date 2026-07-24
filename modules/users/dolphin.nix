# Dolphin as the system file manager, themed Catppuccin Mocha Lavender.
# Runs outside Plasma (niri), so theming is done via the KConfig cascade:
# KDE apps read /etc/xdg/kdeglobals when no ~/.config/kdeglobals overrides it.
{
  flake.modules.nixos.users-dolphin =
    { pkgs, ... }:
    let
      catppuccinKde = pkgs.catppuccin-kde.override {
        flavour = [ "mocha" ];
        accents = [ "lavender" ];
        winDecStyles = [ "modern" ];
      };
    in
    {
      environment.systemPackages = with pkgs; [
        kdePackages.dolphin
        kdePackages.kio-extras # thumbnails, archive/network protocols
        kdePackages.qtsvg # SVG icon rendering
        kdePackages.breeze-icons # icon fallback
        catppuccinKde
        (catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        })
      ];

      # plasma-integration platform theme makes Qt/KDE apps apply the palette
      # from kdeglobals; Breeze draws the widgets with it. Without this, Qt
      # falls back to its default (light) palette outside Plasma.
      qt = {
        enable = true;
        platformTheme = "kde";
        style = "breeze";
      };

      # Inline the full color scheme so Dolphin gets the palette without Plasma
      # applying it; the [Colors:*] groups are what Plasma would copy in.
      environment.etc."xdg/kdeglobals".text = ''
        [Icons]
        Theme=Papirus-Dark

      ''
      + builtins.readFile "${catppuccinKde}/share/color-schemes/CatppuccinMochaLavender.colors";

      # Default file manager for anything that opens directories
      xdg.mime.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";
    };
}
