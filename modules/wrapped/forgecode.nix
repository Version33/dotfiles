{ inputs, ... }:
{
  flake-file.inputs.forgecode.url = "github:tailcallhq/forgecode";

  flake.modules.nixos.forgecode =
    { pkgs, ... }:
    let
      forgePkg = inputs.forgecode.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Provider config pointing forge at the local meridian proxy.
      # MERIDIAN_FORGE_KEY must be set in the environment (any value works
      # since meridian doesn't enforce API key auth by default).
      forgeConfig = pkgs.writeText ".forge.toml" ''
        [[providers]]
        id            = "meridian"
        url           = "http://127.0.0.1:3456/v1/messages"
        models        = "http://127.0.0.1:3456/v1/models"
        api_key_vars  = "MERIDIAN_FORGE_KEY"
        response_type = "Anthropic"
        auth_methods  = ["api_key"]

        [providers.headers]
        x-meridian-agent = "forgecode"

        [session]
        provider_id = "meridian"
        model_id    = "claude-opus-4-6"
      '';
    in
    {
      environment.systemPackages = [ forgePkg ];

      # Write the provider config to ~/forge/.forge.toml
      systemd.user.tmpfiles.rules = [
        "d %h/forge 0755 - - -"
        "L+ %h/forge/.forge.toml - - - - ${forgeConfig}"
      ];
    };
}
