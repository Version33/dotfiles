{ lib, ... }:
let
  # Path where you store model files (downloaded manually, not managed by Nix)
  # Download with:
  #   huggingface-cli download unsloth/gemma-4-26B-A4B-it-GGUF \
  #     --include "gemma-4-26B-A4B-it-Q4_K_M.gguf" \
  #     --local-dir ~/models
  modelDir = "/home/vee/models";
  modelFile = "gemma-4-26B-A4B-it-UD-Q4_K_M.gguf";

  # OpenAI-compatible API endpoint — point opencode here:
  #   OPENAI_BASE_URL=http://127.0.0.1:8000/v1
  port = 8000;

  ctxSize = 65536;
in
{
  flake.modules.nixos.ai-service =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.llama-cpp.override { vulkanSupport = true; })
      ];

      systemd.user.services.llama-server = {
        description = "llama.cpp inference server — Gemma 4 26B MoE (Vulkan)";

        # Wait for the graphical session so the Vulkan/DRI device is available
        after = [ "graphical-session.target" ];

        serviceConfig = {
          ExecStart = lib.escapeShellArgs [
            "${pkgs.llama-cpp.override { vulkanSupport = true; }}/bin/llama-server"
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
