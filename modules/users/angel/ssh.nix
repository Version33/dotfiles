{
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github.com-angel";
        };
      };

      toSshConfig =
        blocks:
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (host: opts: ''
            Host ${host}
              ${lib.concatStringsSep "\n  " (
                lib.mapAttrsToList (
                  key: value:
                  let
                    sshKey = lib.replaceStrings [ "_" ] [ "" ] (
                      lib.toUpper (builtins.substring 0 1 key) + (builtins.substring 1 (builtins.stringLength key) key)
                    );
                  in
                  if builtins.isBool value then "${sshKey} ${if value then "yes" else "no"}" else "${sshKey} ${value}"
                ) opts
              )}
          '') blocks
        );

      configFile = pkgs.writeText "ssh_config" (toSshConfig matchBlocks);
    in
    {
      packages.ssh-angel = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.openssh;
        flags = {
          "-F" = toString configFile;
        };
      };
    };
}
