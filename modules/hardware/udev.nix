{

  flake.modules.nixos.udev =
    { pkgs, ... }:
    {
      services.udev.extraRules = ''
        # Ableton Push 3
        SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="2982", ENV{ID_MODEL_ID}=="1969", MODE="0660", GROUP="audio"

        # Audient Evo 8
        SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="2708", ENV{ID_MODEL_ID}=="0007", MODE="0660", GROUP="audio"
      '';

      # NuPhy Air75 HE - WebHID access. Shipped as 70-nuphy.rules rather than
      # extraRules (99-local.rules): uaccess is applied in 73-seat-late.rules,
      # so the tag must be set before that to actually grant the seat ACL.
      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "70-nuphy-rules";
          destination = "/etc/udev/rules.d/70-nuphy.rules";
          text = ''
            KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="19f5", ATTRS{idProduct}=="6120", TAG+="uaccess"
          '';
        })
      ];
    };

}
