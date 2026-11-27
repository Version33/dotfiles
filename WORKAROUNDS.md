# Upstream workarounds

Every site in `modules/` that papers over something broken or missing upstream
carries a one-line `# WORKAROUND(<id>)` comment pointing here. Audit with
`grep -rn 'WORKAROUND(' modules`. Last full check: 2026-11-12.

## Waiting on nixos-unstable to catch up with nixpkgs master

nixpkgs' cargo setup hook now forces system libraries for several `*-sys`
crates (`ZSTD_SYS_USE_PKG_CONFIG`, `LIBSQLITE3_SYS_USE_PKG_CONFIG`,
`RUSTONIG_SYSTEM_LIBONIG`, `AWS_LC_SYS_USE_SYSTEM`, sentinel
`JEMALLOC_OVERRIDE`). Packages that don't list the library in `buildInputs`
fail at build time. Master has already fixed the nixpkgs ones; the locked
`nixos-unstable` rev hasn't. All of these become harmless no-ops (duplicate
`buildInputs` entries) once fixed, so removing them is cleanup, not urgency.

### rust-syslibs — `modules/dev/rust.nix`
Adds `zstd` to `dioxus-cli`.
**Remove when** the locked nixpkgs' `pkgs/by-name/di/dioxus-cli/package.nix`
lists `zstd` (master already does, 2026-11-12).

### deadlock-awslc — `modules/users/packages.nix`
Adds `aws-lc`.
**Remove when** `pkgs/by-name/de/deadlock-mod-manager/package.nix` lists it.

### freenet-syslibs — `modules/services/freenet.nix`
freenet-core's own `package.nix` lacks `pkg-config`, `zstd` and jemalloc.
Uses `rust-jemalloc-sys-unprefixed` because the workspace enables
`unprefixed_malloc_on_supported_platforms` (prefixed → undefined `mallocx`).
**Remove when** upstream `package.nix` declares these (check after
`tack update freenet`). Not fixed upstream as of 2026-11-12.

## Waiting on nixpkgs

### xanmod-128bit-patch — `modules/boot/linux-kernel.nix`
`pkgs/top-level/linux-kernels.nix` applies `kernelPatches.tools_128bit_types`
unconditionally to every xanmod/zen variant; the patch landed in Linux 7.3 so
it fails to apply. We filter it out by name.
**Remove when** nixpkgs gates or drops the patch (the filter is a no-op after
that — check `linux-kernels.nix`).

### libratbag-g502xplus / piper-g502xplus — `modules/hardware/mouse.nix`
libratbag 0.18 and piper 0.8 lack G502 X Plus support (libratbag PRs #1693,
#1728; piper `logitech-g502-x-plus.svg`). Both built from master snapshots.
**Remove when** nixpkgs ships libratbag > 0.18 / piper > 0.8. Still 0.18 / 0.8,
no newer upstream tags as of 2026-11-12.

## Waiting on project upstreams

### dux-shell-patches — `modules/packages/dux-shell.nix`
One source patch; **it breaks `patchPhase` when upstream touches the
patched lines** (happened on the 2026-11-11 bump — regenerate with
`sed 's/Name\.String()/Name.ValueString()/g'` + `diff -u` against the new
source, or drop if obsolete).
- `niri-unquote-names`: `niri_parser.go` compares KDL node names via
  `Value.String()`, which keeps quotes, so wrapper-modules' `toKdl` output
  (`"binds"`, `"Mod+Q"`) never matches. Patch uses `ValueString()`.
  **Remove when** upstream no longer calls `Name.String()` there.

### xwayland-satellite-popup — `modules/packages/niri.nix`
Popup X11→logical→X11 round-trip drops a pixel at fractional scale; strict
clients (JUCE in wine/yabridge, e.g. ShaperBox 3) dismiss instantly.
**Remove when** Supreeeme/xwayland-satellite PR #458 merges and nixpkgs ships
a release with it. Still open as of 2026-11-12.

### tobiifree-zig — `modules/hardware/_tobiifree.nix` (module disabled)
Upstream builds with unpinned `pkgs.zig` and follows our nixpkgs, where `zig`
is 0.16; the driver targets 0.15. We pin `zig_0_15`.
**Remove when** the upstream flake pins its own zig.

### osu-diewithparent — `modules/packages/osu.nix`
`bwrap --die-with-parent` kills osu when DMS's short-lived spawn helper exits.
**Remove when** DMS keeps the launcher alive, or nixpkgs `osu-lazer-bin`
exposes `dieWithParent`.

### rtl8126-forced-slave — `modules/network/networking.nix`
On the 5 Gbps link to the BGW320-505 (fw 6.40.4) the RTL8126 (r8169) corrupts
frames whenever it resolves as clock master: 66–72% ping loss, hardware
`rx_errors` climbing; as slave the link is clean. Since 2026-11-16 the gateway
no longer claims master, so every link training (resume, replug, `ethtool -r`)
is a coin flip. A boot oneshot runs `ethtool -s enp10s0 master-slave
forced-slave`. No link against a partner that also forces slave.
**Remove when** `ethtool enp10s0` shows `master-slave status: slave` on ~10
consecutive retrains with the unit disabled (gateway firmware change), or the
NIC/gateway is replaced.

## Deliberately not listed
Pinned inputs in `.tack/pins.toml` (evo-control rev, AppImage URLs,
ableton-linux not following nixpkgs). Those are version pins with bump
instructions, not fixes for broken upstream.

### niri-no-fullscreen-move — `modules/packages/niri.nix`
Preference patch (refuse Mod+LMB move on fullscreen windows instead of
unfullscreening), not a bug fix. Keep as long as wanted; regenerate if niri's
drag code moves.
