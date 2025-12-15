#!/bin/bash

# VLC Player startup script
set -e

# Source environment variables
if [ -f /app/config/env.conf ]; then
    source /app/config/env.conf
fi

# Set default values
VLC_PORT=${VLC_PORT:-8080}
VLC_PASSWORD=${VLC_PASSWORD:-vlcpassword}
PLAYLIST_PATH=${PLAYLIST_PATH:-/app/playlists/default.m3u}

echo "Starting VLC Player..."
echo "Port: $VLC_PORT"
echo "Playlist: $PLAYLIST_PATH"

# Start Xvfb for headless operation
export DISPLAY=:99
Xvfb :99 -screen 0 1024x768x16 &
XVFB_PID=$!

# Ensure cleanup on exit
cleanup() {
    echo "Shutting down VLC Player..."
    kill $XVFB_PID 2>/dev/null || true
    exit 0
}
trap cleanup SIGTERM SIGINT

# Start VLC with HTTP interface
vlc \
    --no-video \
    --intf http \
    --http-host 0.0.0.0 \
    --http-port $VLC_PORT \
    --http-password $VLC_PASSWORD \
    --playlist-autostart \
    --loop \
    --sout-keep \
    --extraintf logger \
    --logfile /app/logs/vlc.log \
    --file-logging \
    $PLAYLIST_PATH &

VLC_PID=$!

# Wait for VLC to start
sleep 5

# Keep the script running
wait $VLC_PID