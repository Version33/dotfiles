{

  flake.modules.nixos.udev = {
    services.udev.extraRules = ''
      # Ableton Push 3
      SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="2982", ENV{ID_MODEL_ID}=="1969", MODE="0660", GROUP="audio"

      # Audient Evo 8
      SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="2708", ENV{ID_MODEL_ID}=="0007", MODE="0660", GROUP="audio"

      # NuPhy Air75 HE - WebHID access
      SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="19f5", ENV{ID_MODEL_ID}=="6120", MODE="0660", GROUP="plugdev", TAG+="uaccess"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="19f5", ATTRS{idProduct}=="6120", MODE="0660", GROUP="plugdev", TAG+="uaccess"

    '';

    # Create plugdev group for WebUSB access
    users.groups.plugdev = { };
  };

}
