{
  flake.modules.nixos.mouse =
    { pkgs, ... }:
    let
      # WORKAROUND(libratbag-g502xplus): 0.18 lacks G502 X Plus; master snapshot — see WORKAROUNDS.md
      libratbag-g502xplus = pkgs.libratbag.overrideAttrs (_old: {
        version = "0.18-unstable-2026-08-13";
        src = pkgs.fetchFromGitHub {
          owner = "libratbag";
          repo = "libratbag";
          rev = "b8d4d3ca1f4d6b23c664ffee2888b8eb669bee21";
          hash = "sha256-8V/LIki/tI/9Wi6kuFJp6k1p+moMh8Gc8RNP1BUlZO8=";
        };
      });

      # WORKAROUND(piper-g502xplus): 0.8 lacks the G502 X Plus diagram; master snapshot — see WORKAROUNDS.md
      piper-g502xplus = pkgs.piper.overrideAttrs (_old: {
        version = "0.8-unstable-2026-08-12";
        src = pkgs.fetchFromGitHub {
          owner = "libratbag";
          repo = "piper";
          rev = "5d3c8845b55643595ccb8029dfa5c7a2fb079e77";
          hash = "sha256-oGa0NXgoiVYadCAB5cnQYrjh3KIVWhTxsSYaB4TVZSA=";
        };
      });
    in
    {
      # ratbagd daemon — provides DBus interface for libratbag device access
      services.ratbagd = {
        enable = true;
        package = libratbag-g502xplus;
      };

      environment.systemPackages = [ piper-g502xplus ];
    };
}
