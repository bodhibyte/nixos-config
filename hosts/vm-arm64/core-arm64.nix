# Core modules adapted for ARM64 VM
# Excludes: hardware.nix (Intel drivers), steam.nix, qmk.nix, virtualization.nix
{ lib, pkgs, ... }:
{
  imports = [
    ./../../modules/core/nixpkgs.nix
    ./../../modules/core/network.nix
    ./../../modules/core/nh.nix
    ./../../modules/core/program.nix
    ./../../modules/core/security.nix
    ./../../modules/core/services.nix
    ./../../modules/core/system.nix
    ./../../modules/core/flatpak.nix
    ./../../modules/core/user.nix
    ./../../modules/core/wayland.nix
    ./../../modules/core/xserver.nix
  ];

  # ARM64-compatible graphics using virtio-gpu
  hardware = {
    graphics = {
      enable = true;
      # No Intel-specific packages for ARM64
    };
  };
  hardware.enableRedistributableFirmware = true;

  # Override pipewire to disable 32-bit support (not available on ARM64)
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = lib.mkForce false;  # Not available on ARM64
    pulse.enable = true;
  };
  hardware.alsa.enablePersistence = true;
  environment.systemPackages = with pkgs; [ pulseaudioFull ];

  # Disable gamescope (not available on ARM64)
  programs.gamescope.enable = lib.mkForce false;

  # Override bootloader settings - handled in default.nix
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
  boot.supportedFilesystems = [ "ntfs" ];
}
