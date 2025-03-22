# Use Ubuntu as base image
FROM ubuntu:latest

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt update && apt install -y \
    sudo \
    openssh-server \
    curl \
    unzip \
    wget \
    nano \
    iproute2 \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create SSH user
RUN useradd -m -s /bin/bash samir && \
    echo "samir:samir090" | chpasswd && \
    mkdir -p /home/samir/.ssh && \
    chmod 700 /home/samir/.ssh && \
    chown -R samir:samir /home/samir/.ssh

# Grant sudo access to the user without requiring a password
RUN echo "samir ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Setup SSH server
RUN mkdir -p /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "AllowUsers samir" >> /etc/ssh/sshd_config

# Install Ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
    unzip ngrok.zip && mv ngrok /usr/local/bin/ngrok && \
    rm ngrok.zip

# Expose all ports
EXPOSE 0-65535

# Start SSH and expose all ports via Ngrok
CMD service ssh start && \
    ngrok authtoken 2lKjA15AAL3kFG0cbOpfTJGbewT_3PjMCSs55KCHQ2PKkoVdS && \
    ngrok tcp 22
