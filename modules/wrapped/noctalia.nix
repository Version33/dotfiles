{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs;
        inherit ((builtins.fromJSON (builtins.readFile ./noctalia.json))) settings;
        # Upstream demotes session actions below app results (`score - 1`)
        package = pkgs.noctalia-shell.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace Modules/Panels/Launcher/Providers/SessionProvider.qml \
              --replace-fail '"_score": score - 1,' '"_score": score + 1,' \
              --replace-fail '"keywords": ["hibernate", "disk"]' '"keywords": ["hibernate"]'
          '';
        });
      };
    };
}
