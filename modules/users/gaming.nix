# Benchmarking / bottleneck diagnosis for games.
#
# Usage (Steam launch options):
#   mangohud gamemoderun %command%
#   gamescope -f -- mangohud gamemoderun %command%   # forced fullscreen, bypasses compositor
#
# In-game: Shift_L+F12 toggles the overlay, Shift_L+F2 starts a 60 s capture
# to ~/mangohud-logs/<game>_<date>.csv (per-frame frametime + GPU/CPU stats).
#
# Reading the overlay:
#   GPU busy ~95-100%            -> GPU-bound, ideal; nothing left to unlock.
#   GPU <80%, one core pinned    -> engine single-thread limit.
#   GPU <80%, all cores low      -> frame cap / vsync / compositor / power profile.
#   GPU core clock below max     -> power or thermal throttle; check in LACT.
{
  flake.modules.nixos.users-gaming =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        mangohud
        nvtopPackages.amd # per-process GPU utilisation / VRAM
        radeontop # AMD per-unit load (shader, VGT, TC...)
      ];

      # capSysNice stays off: the setuid wrapper breaks gamescope launched from
      # inside Steam's FHS sandbox. gamemode already handles priority.
      programs.gamescope.enable = true;

      # System-wide default; ~/.config/MangoHud/MangoHud.conf or a per-game
      # <exe>.conf still takes precedence (MangoHud reads /etc last).
      environment.etc."MangoHud.conf".text = ''
        # Layout
        legacy_layout=0
        position=top-left
        font_size=22
        background_alpha=0.4
        round_corners=6
        toggle_hud=Shift_L+F12

        # Frame pacing
        fps
        frametime
        frame_timing
        fps_limit=0
        fps_metrics=avg,0.01

        # GPU
        gpu_stats
        gpu_core_clock
        gpu_mem_clock
        gpu_power
        gpu_temp
        gpu_fan
        throttling_status
        vram

        # CPU — core_load is what reveals a single-thread bottleneck
        cpu_stats
        cpu_mhz
        cpu_temp
        cpu_power
        core_load
        ram

        # Context
        vulkan_driver
        wine
        gamemode
        resolution
        vsync
        gl_vsync

        # Benchmark capture: Shift_L+F2 logs 60 s of per-frame data to CSV
        toggle_logging=Shift_L+F2
        log_duration=60
        log_interval=0
        output_folder=~/mangohud-logs
        benchmark_percentiles=97,AVG,1,0.1
      '';
    };
}
