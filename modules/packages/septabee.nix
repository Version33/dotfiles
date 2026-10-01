{ inputs, ... }:
{
  flake.modules.nixos.septabee = {
    imports = [ inputs.septabee.nixosModules.default ];

    # Installs the package and wraps septabee/septabee-sounds with
    # cap_sys_nice for realtime audio scheduling.
    programs.septabee.enable = true;
  };
}
