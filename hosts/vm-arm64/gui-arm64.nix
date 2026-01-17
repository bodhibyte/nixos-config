{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    # audacity        # Check if ARM64 supported
    # gimp            # Heavy, maybe skip for VM
    # media-downloader
    # obs-studio      # Heavy
    pavucontrol
    # soundwireserver # x86-only
    # video-trimmer
    vlc

    ## Office
    libreoffice
    gnome-calculator

    ## Utility
    dconf-editor
    gnome-disk-utility
    # popsicle       # Flashing tool, not needed in VM
    mission-center # GUI resources monitor
    zenity

    ## Level editor
    # ldtk
    # tiled
  ];
}
