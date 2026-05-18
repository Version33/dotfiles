{
  flake.modules.nixos.users-common =
    { self, pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;

      crushProviderConfig = pkgs.writeText "crush.json" (
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
            deepseek = {
              type = "openai-compat";
              name = "DeepSeek";
              base_url = "https://api.deepseek.com/v1";
              api_key = "$DEEPSEEK_API_KEY";
              models = [
                {
                  id = "deepseek-v4-pro";
                  name = "DeepSeek V4 Pro";
                  context_window = 1048576;
                  default_max_tokens = 32768;
                  can_reason = true;
                  supports_attachments = false;
                  cost_per_1m_in = 0.435;
                  cost_per_1m_out = 0.87;
                  cost_per_1m_in_cached = 0.003625;
                  cost_per_1m_out_cached = 0;
                }
                {
                  id = "deepseek-v4-flash";
                  name = "DeepSeek V4 Flash";
                  context_window = 1048576;
                  default_max_tokens = 32768;
                  can_reason = true;
                  supports_attachments = false;
                  cost_per_1m_in = 0.14;
                  cost_per_1m_out = 0.28;
                  cost_per_1m_in_cached = 0.0028;
                  cost_per_1m_out_cached = 0;
                }
              ];
            };
          };
        }
      );
    in
    {
      environment.shells = [
        self.packages.${system}.fish
      ];

      security.pam.loginLimits = [
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "nice";
          type = "-";
          value = "-19";
        }
      ];

      systemd.user.tmpfiles.rules = [
        "d %h/.config/crush 0755 - - -"
        "L+ %h/.config/crush/crush.json - - - - ${crushProviderConfig}"
      ];
    };
}
