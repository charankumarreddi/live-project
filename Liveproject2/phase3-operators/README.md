# Phase 3: Updates & Operators

This phase implements advanced deployment strategies with custom operators, CRDs, rolling updates, and Windows workload support.

## Architecture

```
Custom Operator
├── VLCPlayer CRD
├── VLCPlaylist CRD
├── Rolling Update Strategy
├── Rollback Mechanism
├── Windows Node Support
└── Automated Management
```

## Components

### 1. Custom Resource Definitions (CRDs)
- **VLCPlayer**: Main application resource
- **VLCPlaylist**: Playlist management resource
- **VLCConfig**: Configuration management

### 2. VLC Player Operator
- Watches CRD changes
- Manages application lifecycle
- Handles updates and rollbacks
- Implements best practices

### 3. Rolling Updates
- Zero-downtime deployments
- Configurable update strategies
- Health checks during updates
- Automatic rollback on failures

### 4. Windows Support
- Windows node compatibility
- Windows container images
- Platform-specific configurations
- Mixed-OS cluster support

## Features

- ✅ Custom VLC Player operator
- ✅ CRDs for declarative management
- ✅ Rolling updates with health checks
- ✅ Automatic rollback strategies
- ✅ Windows 10/11 workload support
- ✅ Multi-platform deployments
- ✅ Operator pattern implementation
- ✅ GitOps-ready configurations

## Deployment

```bash
# Install CRDs first
kubectl apply -f crds/

# Install RBAC
kubectl apply -f rbac/

# Install Operator
kubectl apply -f operator/

# Create VLC Player instance
kubectl apply -f examples/

# Check operator status
kubectl get deployment vlc-operator -n vlc-system
kubectl logs -f deployment/vlc-operator -n vlc-system
```

## Usage

```bash
# Create a VLC Player instance
kubectl apply -f - <<EOF
apiVersion: media.example.com/v1
kind: VLCPlayer
metadata:
  name: my-vlc-player
spec:
  replicas: 3
  version: "3.0.18"
  platform: linux
  storage:
    size: 10Gi
    storageClass: fast-ssd
EOF

# Update the instance
kubectl patch vlcplayer my-vlc-player --type='merge' -p='{"spec":{"replicas":5}}'

# Check status
kubectl get vlcplayer my-vlc-player -o yaml
```