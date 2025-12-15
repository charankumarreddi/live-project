# Phase 1: DaemonSet & Basic Application

This phase implements a basic VLC Player deployment using Kubernetes DaemonSet, ensuring the application runs on every node in the cluster.

## Architecture

```
DaemonSet
├── ConfigMap (Playlist settings)
├── Secret (Private license key)
├── Pod Template
│   ├── VLC Player Container
│   ├── Resource Limits (CPU/Memory)
│   ├── Liveness Probe
│   ├── Readiness Probe
│   └── Volume Mounts
└── Service (LoadBalancer)
```

## Components

### 1. ConfigMap
- Stores playlist configurations
- Application settings
- Environment variables

### 2. Secret
- Private license key
- HTTP interface password
- Sensitive configuration data

### 3. DaemonSet
- Ensures VLC Player runs on every node
- Manages pod lifecycle
- Implements resource constraints

### 4. Service
- LoadBalancer type for external access
- Exposes VLC HTTP interface
- Port 8080 for web interface

## Deployment

```bash
# Apply all Phase 1 resources
kubectl apply -f .

# Check deployment status
kubectl get daemonset vlc-player-ds
kubectl get pods -l app=vlc-player
kubectl get svc vlc-player-service

# Access VLC web interface
kubectl get svc vlc-player-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

## Monitoring

```bash
# Check pod logs
kubectl logs -l app=vlc-player -f

# Check resource usage
kubectl top pods -l app=vlc-player

# Check probe status
kubectl describe pods -l app=vlc-player
```

## Features

- ✅ DaemonSet ensures pod on every node
- ✅ ConfigMap for configuration management
- ✅ Secret for sensitive data
- ✅ Liveness and readiness probes
- ✅ Resource limits and requests
- ✅ LoadBalancer service for external access