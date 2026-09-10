{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # superfile rewrites its config dir at runtime, so only config.toml is
      # pinned, passed via `-c` (read-only unless `--fix-config-file`).
      configFile = pkgs.writeText "superfile-config.toml" ''
        # This file is intentionally partial; silence the per-launch warning.
        ignore_missing_fields = true

        # bat for syntax-highlighted previews.
        code_previewer = "bat"

        nerdfont = true
        default_open_file_preview = true
        show_image_preview = true

        # size + modify-date columns
        file_panel_extra_columns = 2

        # On quit, write `cd '<dir>'` to $XDG_STATE_HOME/superfile/lastdir;
        # the `spf` fish function sources it. (`--print-last-dir` is unusable:
        # the TUI itself renders to stdout, so capturing it hides the UI.)
        cd_on_quit = true
      '';
    in
    {
      packages.superfile =
        (inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.superfile;
          runtimePkgs = [ pkgs.bat ]; # code_previewer = "bat"
          # cd-on-quit lives in the `spf` fish function, not here.
          flags = {
            "-c" = "${configFile}";
          };
        })
        // {
          inherit configFile;
        };
    };
}
