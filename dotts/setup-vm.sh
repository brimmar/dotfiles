#!/usr/bin/env bash
set -euo pipefail

ISO_URL="https://iso.pop-os.org/24.04/amd64/nvidia/13/pop-os_24.04_amd64_nvidia_13.iso"
ISO_DEST="$HOME/Downloads/pop-os_24.04_amd64_nvidia_13.iso"
VM_NAME="PopOS-24.04-Nvidia"

echo "==> Checking for Pop!_OS 24.04 LTS NVIDIA ISO..."
if [ ! -f "$ISO_DEST" ]; then
  echo "==> Downloading ISO (~2.86 GB) with resume support..."
  wget -c --show-progress "$ISO_URL" -O "$ISO_DEST"
else
  echo "==> Found existing ISO at $ISO_DEST"
fi

echo "==> Attaching ISO to $VM_NAME..."
vboxmanage storageattach "$VM_NAME" \
  --storagectl "IDE" \
  --port 0 \
  --device 0 \
  --type dvddrive \
  --medium "$ISO_DEST"

echo "==> Starting $VM_NAME..."
vboxmanage startvm "$VM_NAME"

echo ""
echo "==> VM started! Once installation finishes:"
echo "    1. Add host SSH key: ssh-copy-id brimmar@<VM_HOST_ONLY_IP>"
echo "    2. Clone or rsync dotfiles: rsync -avz ~/dotfiles brimmar@<VM_HOST_ONLY_IP>:~/"
echo "    3. Test dotts: cd ~/dotfiles/dotts && dotts apply dotts.ts --dry-run"
