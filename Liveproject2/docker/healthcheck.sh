#!/bin/bash

# Health check script for VLC Player
VLC_PORT=${VLC_PORT:-8080}
VLC_PASSWORD=${VLC_PASSWORD:-vlcpassword}

# Check if VLC HTTP interface is responding
curl -f -u ":$VLC_PASSWORD" "http://localhost:$VLC_PORT/requests/status.xml" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "VLC Player is healthy"
    exit 0
else
    echo "VLC Player health check failed"
    exit 1
fi