{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      configFile = "${./starship.toml}";
    in
    {
      packages.starship =
        (inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.starship;
          # envDefault, so an explicit STARSHIP_CONFIG still overrides this.
          # Covers direct invocations (nix run, yazi's prompt plugin, …).
          envDefault = {
            STARSHIP_CONFIG = configFile;
          };
        })
        # `starship init` embeds current_exe(), i.e. the UNWRAPPED binary, in
        # the generated prompt function — the wrapper env never reaches those
        # prompt-time calls. Shell integrations must export this themselves.
        // {
          inherit configFile;
        };
    };
}
