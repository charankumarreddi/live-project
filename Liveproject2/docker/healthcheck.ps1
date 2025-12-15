# VLC Player Windows health check script

# Set error handling
$ErrorActionPreference = "Stop"

# Configuration
$vlcPort = $env:VLC_PORT
if (-not $vlcPort) { $vlcPort = 8080 }

$vlcPassword = $env:VLC_PASSWORD
if (-not $vlcPassword) { $vlcPassword = "vlcpassword" }

try {
    # Create credentials for basic auth
    $credentials = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$vlcPassword"))
    
    # Create headers
    $headers = @{
        "Authorization" = "Basic $credentials"
    }
    
    # Check VLC HTTP interface
    $uri = "http://localhost:$vlcPort/requests/status.xml"
    $response = Invoke-WebRequest -Uri $uri -Headers $headers -TimeoutSec 5 -UseBasicParsing
    
    if ($response.StatusCode -eq 200) {
        Write-Host "VLC Player is healthy"
        exit 0
    } else {
        Write-Host "VLC Player health check failed - HTTP $($response.StatusCode)"
        exit 1
    }
}
catch {
    Write-Host "VLC Player health check failed: $_"
    exit 1
}