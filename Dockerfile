# Ubuntu 22.04 base image
FROM ubuntu:22.04

# Non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    git \
    vim \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install ttyd (Web-based Terminal)
RUN RUNTIME_ARCH=$(uname -m) && \
    curl -Lo /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.${RUNTIME_ARCH} && \
    chmod +x /usr/local/bin/ttyd

# Create a user (Railway usually runs as root, but sudo is available)
# Yahan password 'root' set kiya hai
RUN echo 'root:root' | chpasswd

# Expose the port Railway will use
EXPOSE 7681

# Command to run ttyd and launch bash
# -W allows writing, -p is the port
CMD ["sh", "-c", "/usr/local/bin/ttyd -p 7681 -W bash"]

