{ inputs, ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      pname = "septabee";

      # Proprietary offline build, not redistributable, so the 7z lives outside
      # git as a `file+file://` input. To update: replace it, bump version + URL
      # in modules/flake.nix, then `nix run .#write-flake && nix flake lock`.
      version = "B_T14";

      # GLFW app: everything below is dlopen'd at runtime, so it must be on
      # LD_LIBRARY_PATH rather than resolved by autoPatchelf (which only sees
      # DT_NEEDED: libX11, libstdc++).
      runtimeLibs = with pkgs; [
        libglvnd # libGL/libEGL/libGLESv2/libOpenGL
        vulkan-loader
        wayland # libwayland-client/-cursor/-egl
        libdecor
        libxkbcommon
        libxcursor
        libxext
        libxi
        libxinerama
        libxrandr
        libxrender
        libxxf86vm
        libx11
        pipewire # libpipewire-0.3
        pipewire.jack # libjack
      ];

      # The archive ships no .desktop or icon; StartupWMClass matches the
      # app_id GLFW sets so the launcher groups its window.
      desktopItem = pkgs.makeDesktopItem {
        name = pname;
        desktopName = "Septabee";
        exec = pname;
        terminal = false;
        categories = [
          "AudioVideo"
          "Audio"
        ];
        startupWMClass = pname;
      };
    in
    {
      packages.septabee = pkgs.stdenv.mkDerivation {
        inherit pname version;
        src = "${inputs.septabee-bin}";

        nativeBuildInputs = with pkgs; [
          p7zip
          autoPatchelfHook
          makeWrapper
        ];
        buildInputs = with pkgs; [
          libx11
          stdenv.cc.cc.lib
        ];

        unpackPhase = ''
          7z x -y "$src" >/dev/null
          sourceRoot=linux
        '';

        # The binary locates its data files, fonts, helper executables
        # (septabee-sounds, septabee-watchdawg) and stuffs/ relative to
        # /proc/self/exe, so keep the archive layout intact under lib/ and
        # exec the real binary from a wrapper (not a symlink copy).
        installPhase = ''
          runHook preInstall
          mkdir -p $out/lib/${pname} $out/bin
          cp -r . $out/lib/${pname}/
          chmod +x $out/lib/${pname}/${pname} \
                   $out/lib/${pname}/${pname}-sounds \
                   $out/lib/${pname}/${pname}-watchdawg
          makeWrapper $out/lib/${pname}/${pname} $out/bin/${pname} \
            --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}
          install -Dm444 ${desktopItem}/share/applications/${pname}.desktop \
            $out/share/applications/${pname}.desktop
          runHook postInstall
        '';

        meta = {
          description = "Septabee";
          license = lib.licenses.unfree;
          mainProgram = pname;
          platforms = [ "x86_64-linux" ];
        };
      };
    };
}
