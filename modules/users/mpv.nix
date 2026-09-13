# mpv as the system media player: installed and registered as the default
# handler for audio/video so double-clicking in Dolphin (or `xdg-open`) opens it.
{
  flake.modules.nixos.users-mpv =
    { pkgs, lib, ... }:
    let
      # mimeapps.list has no globbing, so the types are enumerated explicitly.
      mediaTypes = [
        # Video
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "video/quicktime"
        "video/x-msvideo"
        "video/x-ms-wmv"
        "video/x-flv"
        "video/mpeg"
        "video/mp2t"
        "video/3gpp"
        "video/3gpp2"
        "video/ogg"
        "video/x-ogm+ogg"
        "video/x-theora+ogg"
        "video/vnd.rn-realvideo"
        "video/dv"
        "video/x-m4v"
        "video/x-nsv"
        "application/x-matroska"
        "application/ogg"
        "application/vnd.rn-realmedia"
        "application/x-mpegurl"
        "application/vnd.apple.mpegurl"
        # Audio
        "audio/mpeg"
        "audio/mp4"
        "audio/x-m4a"
        "audio/aac"
        "audio/flac"
        "audio/x-flac"
        "audio/ogg"
        "audio/x-vorbis+ogg"
        "audio/x-opus+ogg"
        "audio/x-wav"
        "audio/x-aiff"
        "audio/x-ms-wma"
        "audio/x-musepack"
        "audio/x-ape"
        "audio/x-wavpack"
        "audio/x-tta"
        "audio/x-matroska"
        "audio/webm"
        "audio/x-mpegurl"
        "audio/x-scpls"
        "audio/vnd.rn-realaudio"
        "audio/AMR"
        "audio/AMR-WB"
      ];
    in
    {
      environment.systemPackages = [ pkgs.mpv ];

      xdg.mime.defaultApplications = lib.genAttrs mediaTypes (_: "mpv.desktop");
    };
}
