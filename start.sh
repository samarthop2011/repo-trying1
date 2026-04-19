#!/bin/bash

# Check if KVM is available on the host
if [ -e /dev/kvm ]; then
    echo "KVM is available! Accelerating..."
    KVM_ACCEL="-enable-kvm -cpu host"
else
    echo "KVM not available. Using emulation..."
    KVM_ACCEL="-cpu qemu64"
fi

# Launch ttyd with QEMU
# We use -m 2G for stability on Railway
ttyd -p 7681 qemu-system-x86_64 \
    $KVM_ACCEL \
    -m 2G \
    -smp 2 \
    -drive file=/os.img,format=qcow2 \
    -nographic \
    -serial mon:stdio \
    -net user,hostfwd=tcp::2222-:22 \
    -net nic
