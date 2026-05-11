{
  perSystem =
    { pkgs, ... }:
    let
      # A keepalive launcher: sh forks steam as a child, steam execs into bwrap,
      # but sh stays alive as the systemd scope's main process — preventing
      # niri's transient systemd scope from being cleaned up before Steam boots.
      steam-launcher = pkgs.writeShellScriptBin "steam-launcher" ''
        steam "$@"
      '';
    in
    {
      packages.steam-launcher = steam-launcher;

      packages.steam-desktop-item = pkgs.makeDesktopItem {
        name = "steam";
        desktopName = "Steam";
        comment = "Application for managing and playing games on Steam";
        exec = "${steam-launcher}/bin/steam-launcher";
        icon = "steam";
        categories = [
          "Network"
          "FileTransfer"
          "Game"
        ];
        mimeTypes = [
          "x-scheme-handler/steam"
          "x-scheme-handler/steamlink"
        ];
      };
    };
}
