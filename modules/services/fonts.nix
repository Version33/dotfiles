{

  flake.modules.nixos.fonts =
    { pkgs, ... }:
    {
      # Fonts
      fonts.packages = with pkgs; [
        # jetbrains-mono
        # nerd-fonts._0xproto
        nerd-fonts.jetbrains-mono
        # nerd-font-patcher
        # noto-fonts-monochrome-emoji
      ];

      # Set default fonts
      fonts.fontconfig.defaultFonts = {
        monospace = [ "JetBrains Mono" ];
      };
    };

}
