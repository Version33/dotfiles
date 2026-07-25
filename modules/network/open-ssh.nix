{

  flake.modules.nixos.open-ssh = _: {
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "vee" ];
      };
    };
  };

}
