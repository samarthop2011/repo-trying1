FROM ubuntu:22.04

# Install QEMU, ttyd, and tools
RUN apt-get update && apt-get install -y \
    qemu-system-x86 qemu-utils ttyd wget curl \
    && rm -rf /var/lib/apt/lists/*

# Download actual Ubuntu Cloud Image
RUN wget -q -O /os.img https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img

# Setup the launch script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 7681
CMD ["/start.sh"]
