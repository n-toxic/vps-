# Base OS
FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Web tools, SSH Server, Bot dependencies, and Terminal multiplexers
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    git \
    vim \
    nano \
    openssh-server \
    tmux \
    screen \
    python3 \
    python3-pip \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install ttyd (Web Terminal)
RUN RUNTIME_ARCH=$(uname -m) && \
    curl -Lo /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.${RUNTIME_ARCH} && \
    chmod +x /usr/local/bin/ttyd

# Configure SSH Server
RUN mkdir -p /run/sshd
# Yahan SSH ka password 'railway' set kiya hai (Aap badal sakte hain)
RUN echo 'root:railway' | chpasswd
# Root login allow karein
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create a Startup Script (Removed the --writable flag)
RUN echo '#!/bin/bash\n\
# Start SSH server in background\n\
/usr/sbin/sshd\n\
# Railway dynamic port, default to 8080\n\
PORT=${PORT:-8080}\n\
# Start web terminal in foreground (Writable by default now)\n\
exec /usr/local/bin/ttyd --port $PORT bash\n\
' > /start.sh && chmod +x /start.sh

# Start the container
CMD ["/start.sh"]
