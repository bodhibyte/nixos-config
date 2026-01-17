#!/usr/bin/env bash
# Build NixOS ARM64 VM Image
# This script builds a bootable disk image for the vm-arm64 configuration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="${REPO_ROOT}/result-vm"

cd "$REPO_ROOT"

echo "🔨 Building NixOS ARM64 VM disk image..."
echo "   This may take a while on first build..."
echo ""

# Build the VM configuration
# Use qcow2 format for QEMU disk image
nix build .#nixosConfigurations.vm-arm64.config.system.build.vm \
    --show-trace \
    -o "$OUTPUT_DIR"

echo ""
echo "✅ Build complete!"
echo ""
echo "To run the VM, use: ./scripts/run-vm-macos.sh"
echo ""
echo "Output located at: $OUTPUT_DIR"
