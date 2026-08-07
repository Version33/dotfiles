{

  flake.modules.nixos.internationalisation =
    { pkgs, ... }:
    {
      i18n.defaultLocale = "en_US.UTF-8";

      environment.systemPackages = with pkgs; [
        nuspell
        hyphen
        hunspell
        hunspellDicts.en_US
      ];
    };

}
