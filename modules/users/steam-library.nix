{
  flake.modules.nixos.users-steam-library =
    { ... }:
    let
      sharedLibrary = "/var/lib/steam-library";
    in
    {
      users.groups.games = { };

      systemd.tmpfiles.rules = [
        "d ${sharedLibrary} 2775 root games - -"
        "d ${sharedLibrary}/steamapps 2775 root games - -"
        "f ${sharedLibrary}/steamapps/libraryfolder.vdf 0664 root games - -"
      ];
    };
}
