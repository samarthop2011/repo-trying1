FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    ttyd \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Use the "Minimal" image - it's much lighter
RUN wget -O /os.img https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img

RUN echo '#!/bin/bash \n\
# Lowered RAM to 1G and CPU to 1 to stay under Railway limits
# Added "init=/bin/bash" to stop it from loading the "Welcome" services that crash it
ttyd -p 7681 qemu-system-x86_64 \
    -m 1G \
    -smp 1 \
    -cpu qemu64 \
    -drive file=/os.img,format=qcow2 \
    -nographic \
    -serial mon:stdio \
    -append "root=/dev/sda1 console=ttyS0 init=/bin/bash rw"' > /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 7681

CMD ["/entrypoint.sh"]
