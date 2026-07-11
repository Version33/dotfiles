let
  mkYazi =
    pkgs:
    pkgs.yazi.override {
      settings.theme = builtins.fromTOML (
        builtins.readFile (
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/yazi/baaf5d1c9427b836fbefd126aa855f9eab7a9d0d/themes/mocha/catppuccin-mocha-blue.toml";
            sha256 = "137c4z3i27hrq5h3ff7cmnz4bkbxxrq9jixv2kl0c7b10cqmpibv";
          }
        )
      );
      plugins = with pkgs; {
        "wl-clipboard" = yaziPlugins.wl-clipboard;
        "starship" = yaziPlugins.starship;
        "full-border" = yaziPlugins.full-border;
      };
      extraPackages = with pkgs; [
        starship # fancy shell prompt
        sox # spectrogram previews
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
      settings.keymap.mgr.prepend_keymap = [
        {
          on = "<C-y>";
          run = "plugin wl-clipboard";
          desc = "Copy file(s) to system clipboard";
        }
      ];
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.yazi = mkYazi pkgs;
    };

}
