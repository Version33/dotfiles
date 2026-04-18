{ lib, ... }:
let
  # Path where you store model files (downloaded manually, not managed by Nix)
  # Download with:
  #   huggingface-cli download unsloth/gemma-4-26B-A4B-it-GGUF \
  #     --include "gemma-4-26B-A4B-it-Q4_K_M.gguf" \
  #     --local-dir ~/models
  modelDir = "/home/vee/models";
  modelFile = "gemma-4-26B-A4B-it-UD-Q4_K_M.gguf";

  # OpenAI-compatible API endpoint — point opencode/crush here:
  #   OPENAI_BASE_URL=http://127.0.0.1:8000/v1
  port = 8000;

  # Context window (tokens). 32K is a good default for coding; bump to 65536 if
  # you need larger files in context and VRAM allows.
  ctxSize = 32768;
in
{
  flake.modules.nixos.ai-service =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        # Built with Vulkan — recommended backend for RDNA 4 (RX 9070 XT).
        # ROCm HIP has active hanging bugs on gfx1201 as of 2026; Vulkan also
        # benchmarks faster (~62 tok/s vs ~48 tok/s on the same hardware).
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
