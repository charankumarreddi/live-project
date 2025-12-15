# VLC Player Container Image
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install VLC and required dependencies
RUN apt-get update && apt-get install -y \
    vlc \
    vlc-plugin-base \
    vlc-plugin-video-output \
    curl \
    wget \
    dbus-x11 \
    xvfb \
    pulseaudio \
    alsa-utils \
    && rm -rf /var/lib/apt/lists/*

# Create vlc user
RUN useradd -m -s /bin/bash vlc

# Create directories for media and configuration
RUN mkdir -p /app/media /app/config /app/playlists /app/logs \
    && chown -R vlc:vlc /app

# Copy application scripts
COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*.sh

# Health check script
COPY healthcheck.sh /app/healthcheck.sh
RUN chmod +x /app/healthcheck.sh

# Copy default configuration
COPY config/ /app/config/

# Set working directory
WORKDIR /app

# Switch to vlc user
USER vlc

# Expose VLC HTTP interface port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /app/healthcheck.sh

# Default command
CMD ["/app/scripts/start-vlc.sh"]