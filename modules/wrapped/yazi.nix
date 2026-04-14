{ ... }:
{
  flake.modules.nixos.wrapped-yazi =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.yazi.override {
          extraPackages = with pkgs; [
            ffmpeg # video thumbnails
            _7zz # archive extraction and preview
            jq # JSON preview
            poppler-utils # PDF preview
            fd # file searching
            ripgrep # file content searching
            fzf # quick file subtree navigation
            zoxide # historical directory navigation
            resvg # SVG preview
            imagemagick # font, HEIC, and JPEG XL preview
            chafa # image preview in terminal
            wl-clipboard # clipboard support on Wayland
          ];
        })
      ];
    };
}
