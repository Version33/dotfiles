{

  flake.modules.nixos.services =
    { pkgs, ... }:
    {
      # Systemd services setup
      # systemd.packages = with pkgs; [
      #   auto-cpufreq # Automatic CPU speed & power optimizer for Linux # laptop power optimization
      # ];

      # Enable Services
      programs = {
        dconf.enable = true;
        xfconf.enable = true; # Xfce configuration storage system
      };

      services = {
        # upower.enable = true; # D-Bus service for power management.
        dbus = {
          enable = true;
          implementation = "broker";
        };
        tumbler.enable = true; # D-Bus thumbnailer service
        fwupd.enable = true; # DBus service that allows applications to update firmware.
        # auto-cpufreq.enable = true;
        # gnome.core-shell.enable = true;
        # udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
      };

      systemd.packages = [ pkgs.psi-notify ];
      systemd.user.services.psi-notify.wantedBy = [ "default.target" ];

      hardware.opentabletdriver.enable = true;

      environment.systemPackages = with pkgs; [
        at-spi2-atk # Assistive Technology Service Provider Interface protocol definitions and daemon for D-Bus.
        qt6.qtwayland # Cross-platform application framework for C++
        psi-notify # Alert on system resource saturation.
        # poweralertd # UPower-powered power alerter.
        playerctl # Command-line utility and library for controlling media players that implement MPRIS.
        psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
        grim # Grab images from a Wayland compositor.
        slurp # Select a region in a Wayland compositor.
        swappy # Wayland native snapshot editing tool, inspired by Snappy on macOS.
        ffmpeg-full # Complete, cross-platform solution to record, convert and stream audio and video.
        wl-screenrec # High performance wlroots screen recording, featuring hardware encoding.
        wl-clipboard # Command-line copy/paste utilities for Wayland.
        wl-clip-persist # Keep Wayland clipboard even after programs close.
        cliphist # Wayland clipboard manager.
        xdg-utils # Set of command line tools that assist applications with a variety of desktop integration tasks.
        wtype # xdotool type for wayland.
        wlrctl # Command line utility for miscellaneous wlroots Wayland extensions.
        gifsicle # Command-line tool for creating, editing, and getting information about GIF images and animations.
      ];
    };

}
