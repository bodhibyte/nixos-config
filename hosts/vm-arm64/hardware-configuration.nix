{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "virtio_net"
    "virtio_gpu"
    "xhci_pci"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Root filesystem - will be configured on disk image
  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  # EFI system partition for UEFI boot
  fileSystems."/boot" = {
    device = "/dev/vda1";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  # Enable DHCP for networking
  networking.useDHCP = lib.mkDefault true;

  # ARM64 platform
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
