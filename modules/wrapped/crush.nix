{
  self,
  inputs,
  ...
}:
{
  # Charm's agentic coding tool - available via NUR (Nix User Repository)
  flake-file.inputs.nur.url = "github:nix-community/NUR";

  perSystem =
    { pkgs, ... }:
    {
      packages.crush =
        (import inputs.nur {
          inherit pkgs;
          nurpkgs = pkgs;
        }).repos.charmbracelet.crush;
    };

  flake.modules.nixos.crush =
    { pkgs, ... }:
    let
      # Written to ~/.config/crush/crush.json — crush's user config file.
      # This is separate from providers.json (crush's internal catalog).
      # The base_url field points crush at the local llama-server instance.
      localProviderConfig = pkgs.writeText "crush.json" (
        builtins.toJSON {
          providers = {
            local = {
              name = "Local (llama.cpp)";
              type = "openai";
              base_url = "http://127.0.0.1:8000/v1";
              api_key = "none";
              models = [
                {
                  id = "gemma-4-26b";
                  name = "Gemma 4 26B MoE (local)";
                  context_window = 65536;
                  default_max_tokens = 65536;
                  cost_per_1m_in = 0;
                  cost_per_1m_out = 0;
                  cost_per_1m_in_cached = 0;
                  cost_per_1m_out_cached = 0;
                }
              ];
            };
          };
        }
      );
    in
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.crush
      ];

      # Symlink the local provider config into the crush config dir.
      # crush reads ~/.config/crush/crush.json as user config and merges it
      # with its built-in provider catalog — this is the documented approach.
      systemd.user.tmpfiles.rules = [
        "d %h/.config/crush 0755 - - -"
        "L+ %h/.config/crush/crush.json - - - - ${localProviderConfig}"
      ];
    };
}
