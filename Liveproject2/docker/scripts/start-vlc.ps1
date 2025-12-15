# VLC Player Windows startup script

# Set error handling
$ErrorActionPreference = "Stop"

# Read configuration
$configPath = "C:\app\config\env.conf"
$vlcPort = 8080
$vlcPassword = "vlcpassword"
$playlistPath = "C:\app\playlists\default.m3u"

if (Test-Path $configPath) {
    Get-Content $configPath | ForEach-Object {
        if ($_ -match "^VLC_PORT=(.+)$") { $vlcPort = $matches[1] }
        if ($_ -match "^VLC_PASSWORD=(.+)$") { $vlcPassword = $matches[1] }
        if ($_ -match "^PLAYLIST_PATH=(.+)$") { $playlistPath = $matches[1] }
    }
}

Write-Host "Starting VLC Player on Windows..."
Write-Host "Port: $vlcPort"
Write-Host "Playlist: $playlistPath"

# Find VLC executable
$vlcPath = Get-Command vlc -ErrorAction SilentlyContinue
if (-not $vlcPath) {
    $vlcPath = "C:\Program Files\VideoLAN\VLC\vlc.exe"
    if (-not (Test-Path $vlcPath)) {
        $vlcPath = "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
        if (-not (Test-Path $vlcPath)) {
            Write-Error "VLC executable not found"
            exit 1
        }
    }
}

# Prepare VLC arguments
$vlcArgs = @(
    "--no-video",
    "--intf", "http",
    "--http-host", "0.0.0.0",
    "--http-port", $vlcPort,
    "--http-password", $vlcPassword,
    "--playlist-autostart",
    "--loop",
    "--sout-keep",
    "--extraintf", "logger",
    "--logfile", "C:\app\logs\vlc.log",
    "--file-logging"
)

# Add playlist if it exists
if (Test-Path $playlistPath) {
    $vlcArgs += $playlistPath
}

# Start VLC
try {
    Write-Host "Starting VLC with arguments: $($vlcArgs -join ' ')"
    $vlcProcess = Start-Process -FilePath $vlcPath -ArgumentList $vlcArgs -PassThru -WindowStyle Hidden
    
    # Wait for VLC to start
    Start-Sleep -Seconds 10
    
    # Keep the script running
    while ($vlcProcess -and -not $vlcProcess.HasExited) {
        Start-Sleep -Seconds 30
        Write-Host "VLC Player is running (PID: $($vlcProcess.Id))"
    }
    
    Write-Host "VLC Player has stopped"
}
catch {
    Write-Error "Failed to start VLC Player: $_"
    exit 1
}