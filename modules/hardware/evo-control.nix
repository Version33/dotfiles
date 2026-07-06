{
  flake.modules.nixos.evo-control =
    {
      inputs,
      pkgs,
      config,
      lib,
      ...
    }:
    let
      evo-control-pkg = pkgs.rustPlatform.buildRustPackage {
        pname = "evo-control";
        version = "0.1.0";
        src = inputs.evo-control;

        cargoLock = {
          lockFile = inputs.evo-control + "/Cargo.lock";
        };

        nativeBuildInputs = with pkgs; [
          pkg-config
          makeWrapper
          copyDesktopItems
        ];

        buildInputs = with pkgs; [
          libGL
          wayland
          libxkbcommon
          fontconfig
          alsa-lib
        ];

        desktopItems = [
          (pkgs.makeDesktopItem {
            name = "evo-control";
            exec = "evo-control";
            icon = "evo-control";
            desktopName = "evo-control";
            comment = "Audient EVO 8 mixer control";
            categories = [
              "Audio"
              "AudioVideo"
              "Mixer"
            ];
            keywords = [
              "audio"
              "mixer"
              "EVO"
              "Audient"
            ];
            startupNotify = true;
          })
        ];

        postInstall = ''
          wrapProgram $out/bin/evo-control \
            --prefix LD_LIBRARY_PATH : ${
              lib.makeLibraryPath (
                with pkgs;
                [
                  wayland
                  libxkbcommon
                  libGL
                  fontconfig
                  alsa-lib
                ]
              )
            }

          mkdir -p $out/share/icons/hicolor/scalable/apps
          cp ${inputs.evo-control}/packaging/evo-control.svg $out/share/icons/hicolor/scalable/apps/evo-control.svg
        '';

        meta = with lib; {
          description = "GUI and CLI for the Audient EVO 8 USB audio interface";
          homepage = "https://github.com/briannadon/evo-control";
          license = with licenses; [
            mit
            asl20
          ];
          mainProgram = "evo-control";
          platforms = platforms.linux;
        };
      };

      evo-raw-kmod = pkgs.callPackage (
        { stdenv, kernel }:
        stdenv.mkDerivation {
          name = "evo_raw-${kernel.modDirVersion}";
          src = "${inputs.evo-control}/kmod";
          nativeBuildInputs = kernel.moduleBuildDependencies;
          makeFlags = [
            "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
          ];
          preBuild = ''
            # Fix: LLVM=0 is invalid for kernel >=6.x; only set LLVM when Clang kernel
            sed -i '/^LLVM/s/?=.*/?=/' Makefile
          '';
          installPhase = ''
            mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/usb/misc
            cp evo_raw.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/usb/misc/
          '';
          meta.platforms = lib.platforms.linux;
        }
      ) { kernel = config.boot.kernelPackages.kernel; };

      # NOTE: No device profile is forced here so you can toggle between
      # stereo and pro-audio mode on the fly. To switch profiles:
      #   pavucontrol → Configuration tab → pick a profile
      #   or: pactl set-card-profile <card> output:analog-stereo
      #   or: pactl set-card-profile <card> pro-audio
      evo-wireplumber-config = pkgs.writeTextDir "50-evo-routing.conf" ''
        monitor.alsa.rules = [
          {
            matches = [{ "node.name" = "alsa_output.usb-Audient_EVO8-*" }]
            actions = {
              update-props = {
                session.suspend-timeout-seconds = 0
              }
            }
          }
          {
            matches = [{ "node.name" = "alsa_input.usb-Audient_EVO8-*" }]
            actions = {
              update-props = {
                session.suspend-timeout-seconds = 0
              }
            }
          }
        ]
      '';

    in
    {
      environment.systemPackages = [ evo-control-pkg ];

      boot.extraModulePackages = [ evo-raw-kmod ];
      boot.kernelModules = [ "evo_raw" ];

      services.udev.extraRules = ''
        # evo-control: grant audio group access to /dev/evo8
        ACTION=="add", SUBSYSTEM=="misc", KERNEL=="evo8", MODE="0660", GROUP="audio", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="evo-control-preset.service"
      '';

      environment.etc."wireplumber/wireplumber.conf.d/50-evo-routing.conf" = {
        source = "${evo-wireplumber-config}/50-evo-routing.conf";
        user = "root";
      };

      environment.etc."evo-control/presets/main.toml".text = ''
        schema = 1
        output_volume_db = [-12.0, -96.0]
        input_gain_db = [30.0, -8.0, -8.0, -8.0]
        phantom = [true, false, false, false]
        input_mute = [false, false, false, false]
        output_mute = false
        mixer = [[-25.0, -25.0, -128.0, -128.0], [-128.0, -128.0, -128.0, -128.0], [-128.0, -128.0, -128.0, -128.0], [-128.0, -128.0, -128.0, -128.0], [-10.0, -128.0, -128.0, -128.0], [-128.0, -10.0, -128.0, -128.0], [-128.0, -128.0, -128.0, -128.0], [-128.0, -128.0, -128.0, -128.0], [-128.0, -128.0, -128.0, -128.0], [-128.0, -128.0, -128.0, -128.0]]
      '';
    };
}
