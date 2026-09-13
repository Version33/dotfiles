{ inputs, ... }:
{
  perSystem =
    { pkgs, theme, ... }:
    let
      c = theme.colors.withHashtag;
      # No tinted template for btop; accent boxes/gradients per base16 roles.
      themeFile = pkgs.writeText "${theme.scheme}.theme" ''
        theme[main_bg]="${c.base00}"
        theme[main_fg]="${c.base05}"
        theme[title]="${c.base05}"
        theme[hi_fg]="#${theme.accent}"
        theme[selected_bg]="${c.base02}"
        theme[selected_fg]="${c.base05}"
        theme[inactive_fg]="${c.base03}"
        theme[graph_text]="${c.base05}"
        theme[meter_bg]="${c.base02}"
        theme[proc_misc]="${c.base0C}"
        theme[cpu_box]="#${theme.accent}"
        theme[mem_box]="${c.base0B}"
        theme[net_box]="${c.base0E}"
        theme[proc_box]="${c.base0C}"
        theme[div_line]="${c.base03}"
        theme[temp_start]="${c.base0B}"
        theme[temp_mid]="${c.base0A}"
        theme[temp_end]="${c.base08}"
        theme[cpu_start]="${c.base0D}"
        theme[cpu_mid]="${c.base0E}"
        theme[cpu_end]="${c.base08}"
        theme[free_start]="${c.base0B}"
        theme[free_mid]="${c.base0B}"
        theme[free_end]="${c.base0B}"
        theme[cached_start]="${c.base0C}"
        theme[cached_mid]="${c.base0C}"
        theme[cached_end]="${c.base0C}"
        theme[available_start]="${c.base0A}"
        theme[available_mid]="${c.base0A}"
        theme[available_end]="${c.base0A}"
        theme[used_start]="${c.base08}"
        theme[used_mid]="${c.base08}"
        theme[used_end]="${c.base08}"
        theme[download_start]="${c.base0E}"
        theme[download_mid]="${c.base0E}"
        theme[download_end]="${c.base0E}"
        theme[upload_start]="${c.base0D}"
        theme[upload_mid]="${c.base0D}"
        theme[upload_end]="${c.base0D}"
        theme[process_start]="${c.base0B}"
        theme[process_mid]="${c.base0A}"
        theme[process_end]="${c.base08}"
      '';
      themesDir = pkgs.linkFarm "btop-themes" { "${theme.scheme}.theme" = themeFile; };
      configFile = pkgs.writeText "btop.conf" ''
        color_theme = "${theme.scheme}"
      '';
    in
    {
      packages.btop = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.btop-rocm;
        flags = {
          "--themes-dir" = toString themesDir;
          "-c" = toString configFile;
        };
      };
    };
}
