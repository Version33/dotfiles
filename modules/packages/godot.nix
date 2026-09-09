{
  perSystem =
    { lib, pkgs, ... }:
    let
      # Upstream dev prereleases aren't in nixpkgs; use the official binary.
      # Bump with `nix run .#godot-dev-update`.
      version = "4.8-dev4";
      hash = "sha256-uAXMeRjwm7QJ9ZbQEKdxqtLwPWabU28M2r7HOzFEZTg=";

      src = pkgs.fetchurl {
        url = "https://github.com/godotengine/godot-builds/releases/download/${version}/Godot_v${version}_linux.x86_64.zip";
        inherit hash;
      };

      # The upstream binary dlopens its platform libraries at runtime; none of
      # these are DT_NEEDED, so autoPatchelf can't see them — provide them via
      # the wrapper's LD_LIBRARY_PATH instead.
      libPath = lib.makeLibraryPath (
        with pkgs;
        [
          alsa-lib
          dbus
          fontconfig
          libGL
          libpulseaudio
          libxkbcommon
          speechd-minimal
          udev
          vulkan-loader
          wayland
          libx11
          libxcursor
          libxext
          libxi
          libxinerama
          libxrandr
          libxrender
        ]
      );
    in
    {
      packages.godot = pkgs.stdenv.mkDerivation {
        pname = "godot-bin";
        inherit version src;
        sourceRoot = ".";

        nativeBuildInputs = with pkgs; [
          unzip
          autoPatchelfHook
          makeWrapper
        ];
        buildInputs = [ pkgs.stdenv.cc.cc.lib ];

        installPhase = ''
          runHook preInstall
          install -Dm755 Godot_v${version}_linux.x86_64 $out/libexec/godot
          makeWrapper $out/libexec/godot $out/bin/godot \
            --prefix LD_LIBRARY_PATH : ${libPath}
          install -Dm644 ${pkgs.godot_4}/share/icons/hicolor/scalable/apps/godot.svg \
            $out/share/icons/hicolor/scalable/apps/godot.svg
          mkdir -p $out/share/applications
          cat > $out/share/applications/godot.desktop <<EOF
          [Desktop Entry]
          Name=Godot Engine
          GenericName=Libre game engine
          Exec=godot %f
          Icon=godot
          Terminal=false
          Type=Application
          MimeType=application/x-godot-project;
          Categories=Development;IDE;
          EOF
          runHook postInstall
        '';

        meta = {
          description = "Godot Engine (upstream dev build)";
          homepage = "https://godotengine.org";
          mainProgram = "godot";
          platforms = [ "x86_64-linux" ];
        };
      };

      # Bumps `version`/`hash` above to the newest upstream -dev release.
      # Runs as part of `nix run .#update`.
      # The seds are anchored to the 6-space indent of the actual definition
      # lines so they can never rewrite this script's own embedded patterns.
      packages.godot-dev-update = pkgs.writeShellApplication {
        name = "godot-dev-update";
        runtimeInputs = with pkgs; [
          curl
          jq
          gnused
          nix
        ];
        text = ''
          file=modules/wrapped/godot.nix
          [ -f "$file" ] || { echo "run from the flake root" >&2; exit 1; }
          # Authenticate when possible: the anonymous API quota is per-IP and
          # easily exhausted (shared IPs, other flake-input update checks).
          auth=()
          if token=$(gh auth token 2>/dev/null); then
            auth=(-H "Authorization: Bearer $token")
          fi
          latest=$(curl -fsSL "''${auth[@]}" "https://api.github.com/repos/godotengine/godot-builds/releases?per_page=30" \
            | jq -r '[.[].tag_name | select(test("-dev[0-9]+$"))] | first')
          [ -n "$latest" ] && [ "$latest" != null ] || { echo "no dev release found" >&2; exit 1; }
          current=$(sed -n 's/^      version = "\(.*\)";/\1/p' "$file")
          if [ "$latest" = "$current" ]; then
            echo "godot already at $current"
            exit 0
          fi
          hash=$(nix store prefetch-file --json \
            "https://github.com/godotengine/godot-builds/releases/download/$latest/Godot_v''${latest}_linux.x86_64.zip" \
            | jq -r .hash)
          sed -i \
            -e "s|^      version = \".*\";|      version = \"$latest\";|" \
            -e "s|^      hash = \"sha256-.*\";|      hash = \"$hash\";|" \
            "$file"
          echo "godot updated $current -> $latest"
        '';
      };
    };
}
