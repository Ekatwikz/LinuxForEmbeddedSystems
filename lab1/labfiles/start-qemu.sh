#!/usr/bin/env sh

(
BINARIES_DIR="${0%/*}/"
cd "${BINARIES_DIR}" || exit

export PATH="$HOME/buildroot/output/host/bin:${PATH}"

# With port forwarding for ssh?
exec qemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -smp 1 -kernel Image -append "rootwait root=/dev/vda console=ttyAMA0" -device virtio-net-device,netdev=eth0 -netdev user,id=eth0,hostfwd=tcp::2222-:22
)

