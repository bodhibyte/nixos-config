#!/usr/bin/env bash
# Run NixOS ARM64 VM on macOS M4 with QEMU
# Uses Apple's Hypervisor Framework (HVF) for hardware acceleration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VM_DIR="${REPO_ROOT}/vm-data"
DISK_IMAGE="${VM_DIR}/nixos-arm64.qcow2"
DISK_SIZE="20G"
MEMORY="4G"
CPUS="4"
SSH_PORT="2222"

# UEFI firmware paths (installed via: brew install qemu)
OVMF_CODE="/opt/homebrew/share/qemu/edk2-aarch64-code.fd"
OVMF_VARS_TEMPLATE="/opt/homebrew/share/qemu/edk2-arm-vars.fd"
OVMF_VARS="${VM_DIR}/edk2-arm-vars.fd"

# Check for QEMU
if ! command -v qemu-system-aarch64 &> /dev/null; then
    echo "❌ QEMU not found. Install with: brew install qemu"
    exit 1
fi

# Check for UEFI firmware
if [[ ! -f "$OVMF_CODE" ]]; then
    echo "❌ UEFI firmware not found at: $OVMF_CODE"
    echo "   Make sure QEMU is installed: brew install qemu"
    exit 1
fi

# Create VM data directory
mkdir -p "$VM_DIR"

# Copy OVMF vars if not exists (writable copy)
if [[ ! -f "$OVMF_VARS" ]]; then
    echo "📋 Creating writable UEFI variables store..."
    cp "$OVMF_VARS_TEMPLATE" "$OVMF_VARS"
fi

# Check if we should run in install mode (with ISO)
INSTALL_MODE=false
ISO_PATH=""
if [[ "${1:-}" == "--install" ]]; then
    if [[ -z "${2:-}" ]]; then
        echo "❌ Install mode requires ISO path: $0 --install /path/to/nixos.iso"
        echo ""
        echo "Download NixOS ARM64 ISO from:"
        echo "  https://nixos.org/download.html (select aarch64-linux)"
        exit 1
    fi
    INSTALL_MODE=true
    ISO_PATH="$2"
    echo "🔧 Install mode: Booting from ISO..."
fi

# Create disk image if it doesn't exist
if [[ ! -f "$DISK_IMAGE" ]]; then
    echo "💾 Creating ${DISK_SIZE} disk image..."
    qemu-img create -f qcow2 "$DISK_IMAGE" "$DISK_SIZE"
fi

echo ""
echo "🚀 Starting NixOS ARM64 VM..."
echo "   Memory: ${MEMORY}"
echo "   CPUs: ${CPUS}"
echo "   SSH: localhost:${SSH_PORT}"
echo "   Disk: ${DISK_IMAGE}"
echo ""
echo "   To SSH into the VM: ssh -p ${SSH_PORT} frostphoenix@localhost"
echo "   Default password: nixos"
echo ""

# Build QEMU command
QEMU_ARGS=(
    -name "NixOS-ARM64"
    -machine virt,accel=hvf,highmem=on
    -cpu host
    -smp "$CPUS"
    -m "$MEMORY"
    
    # UEFI firmware
    -drive if=pflash,format=raw,file="$OVMF_CODE",readonly=on
    -drive if=pflash,format=raw,file="$OVMF_VARS"
    
    # Main disk
    -drive file="$DISK_IMAGE",format=qcow2,if=virtio,cache=writethrough
    
    # Networking with SSH port forward
    -device virtio-net-pci,netdev=net0
    -netdev user,id=net0,hostfwd=tcp::"${SSH_PORT}"-:22
    
    # Display
    -device virtio-gpu-pci
    -display cocoa,show-cursor=on
    
    # USB for keyboard/mouse
    -device qemu-xhci
    -device usb-kbd
    -device usb-tablet
    
    # Audio (optional)
    -audiodev coreaudio,id=audio0
    -device intel-hda
    -device hda-duplex,audiodev=audio0
    
    # RNG for faster boot
    -device virtio-rng-pci
    
    # Serial console (useful for debugging)
    -serial mon:stdio
)

# Add ISO for install mode
if [[ "$INSTALL_MODE" == true ]]; then
    QEMU_ARGS+=(
        -drive file="$ISO_PATH",format=raw,if=virtio,media=cdrom,readonly=on
        -boot d
    )
fi

exec qemu-system-aarch64 "${QEMU_ARGS[@]}"
