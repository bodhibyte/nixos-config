{ lib, pkgs, inputs, username, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./core-arm64.nix
  ];

  # ARM64 QEMU uses UEFI, so we use systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      PermitRootLogin = "yes";
    };
  };

  # Set initial password for user (change after first login)
  users.users.${username}.initialPassword = "nixos";
  users.users.root.initialPassword = "nixos";

  # Enable spice-vdagent for VM display/clipboard integration
  services.spice-vdagentd.enable = true;

  # Hyprland in VM requires software rendering
  environment.sessionVariables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
