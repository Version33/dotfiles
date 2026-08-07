{ lib, ... }:
let
  # Path where you store model files (downloaded manually, not managed by Nix)
  # Download with:
  #   huggingface-cli download unsloth/gemma-4-26B-A4B-it-GGUF \
  #     --include "gemma-4-26B-A4B-it-UD-Q4_K_M.gguf" \
  #     --local-dir ~/models
  modelDir = "%h/models";
  modelFile = "gemma-4-26B-A4B-it-UD-Q4_K_M.gguf";

  # OpenAI-compatible API endpoint — point opencode here:
  #   OPENAI_BASE_URL=http://127.0.0.1:8000/v1
  port = 8000;

  ctxSize = 65536;
in
{
  flake.modules.nixos.ai-service =
    { pkgs, ... }:
    let
      llama = pkgs.llama-cpp.override { vulkanSupport = true; };
    in
    {
      environment.systemPackages = [
        llama
      ];

      systemd.user.services.llama-server = {
        description = "llama.cpp inference server — Gemma 4 26B MoE (Vulkan)";
        # No wantedBy on purpose: loads the whole model into VRAM, so start it
        # on demand with `systemctl --user start llama-server`.

        serviceConfig = {
          ExecStart = lib.escapeShellArgs [
            "${llama}/bin/llama-server"
            "--model"
            "${modelDir}/${modelFile}"
            "--port"
            (toString port)
            "--host"
            "127.0.0.1"
            "--n-gpu-layers"
            "99" # offload all layers to GPU
            "--ctx-size"
            (toString ctxSize)
            "--flash-attn"
            "on" # reduces VRAM usage, speeds up long contexts
          ];
          Restart = "on-failure";
          RestartSec = "5";
        };
      };
    };
}
