{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      src = pkgs.fetchFromGitHub {
        owner = "rynfar";
        repo = "meridian";
        rev = "02ddc1e3e5fdb20959297e3f13aba3a11d733944";
        hash = "sha256-WAY1ByGe5foEAkk7VERaGoXRj1YIaMPKkFvd5oMWGxs=";
      };

      nodeModules = pkgs.stdenv.mkDerivation {
        name = "meridian-node-modules";
        inherit src;
        nativeBuildInputs = [
          pkgs.bun
          pkgs.cacert
        ];
        buildPhase = ''
          export HOME=$TMPDIR
          export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
          bun install --frozen-lockfile
        '';
        installPhase = "mv node_modules $out";
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-Z7XiBgBgPCpPE1++1Z3eV9l4IISY4PBmsYflZuhdOSo=";
      };
    in
    {
      packages.meridian = pkgs.stdenv.mkDerivation {
        pname = "meridian";
        version = "1.35.0";
        inherit src;

        nativeBuildInputs = [
          pkgs.bun
          pkgs.makeWrapper
        ];

        buildPhase = ''
          cp -r ${nodeModules} node_modules
          chmod -R u+w node_modules
          bun build bin/cli.ts --outdir dist --target node \
            --external @anthropic-ai/claude-agent-sdk \
            --entry-naming '[name].js'
        '';

        installPhase = ''
          mkdir -p $out/bin $out/lib/meridian
          cp -r dist package.json plugin $out/lib/meridian/
          ln -s ${nodeModules} $out/lib/meridian/node_modules
          makeWrapper ${pkgs.nodejs}/bin/node $out/bin/meridian \
            --add-flags "$out/lib/meridian/dist/cli.js"
        '';

        meta.mainProgram = "meridian";
      };
    };

  flake.modules.nixos.meridian =
    { pkgs, ... }:
    let
      meridian = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.meridian;
    in
    {
      environment.systemPackages = [ pkgs.claude-code ];

      systemd.user.services.meridian = {
        description = "meridian Claude Max proxy";
        path = [
          pkgs.claude-code
          pkgs.which
        ];
        serviceConfig = {
          ExecStart = "${meridian}/bin/meridian";
          Restart = "on-failure";
        };
      };
    };
}
