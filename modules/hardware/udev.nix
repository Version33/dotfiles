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

      # NuPhy Air75 HE - WebHID access. Shipped via services.udev.packages
      # instead of extraRules: extraRules lands in 99-local.rules, which is
      # read after 73-seat-late.rules where systemd's uaccess builtin runs,
      # so a uaccess tag added there is recorded in the udev db but never
      # actually grants an ACL. A rule file below 73 fixes that.
      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "70-nuphy-rules";
          destination = "/etc/udev/rules.d/70-nuphy.rules";
          text = ''
            SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="19f5", ENV{ID_MODEL_ID}=="6120", MODE="0660", GROUP="plugdev", TAG+="uaccess"
            KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="19f5", ATTRS{idProduct}=="6120", MODE="0660", GROUP="plugdev", TAG+="uaccess"
          '';
        })
      ];

      # Create plugdev group for WebUSB access
      users.groups.plugdev = { };
    };

}
