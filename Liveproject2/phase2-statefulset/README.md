# Phase 2: StatefulSet & Autoscaling

This phase implements a StatefulSet deployment with persistent storage and autoscaling capabilities for the VLC Player application.

## Architecture

```
StatefulSet
├── PersistentVolumeClaim Template
├── Persistent Storage (Media files)
├── Horizontal Pod Autoscaler (HPA)
├── Vertical Pod Autoscaler (VPA)
├── Pod Disruption Budget
└── Advanced Monitoring
```

## Components

### 1. StatefulSet
- Ordered deployment and scaling
- Stable network identities
- Persistent storage per pod
- Graceful deployment and scaling

### 2. PersistentVolumeClaims
- Media storage persistence
- Configuration persistence
- Log persistence
- Automatic volume provisioning

### 3. Horizontal Pod Autoscaler (HPA)
- CPU-based scaling
- Memory-based scaling
- Custom metrics scaling
- Min/Max replica limits

### 4. Vertical Pod Autoscaler (VPA)
- Automatic resource optimization
- CPU and memory recommendations
- Update policies
- Quality of Service management

### 5. Pod Disruption Budget
- High availability during updates
- Minimum available pods
- Controlled disruptions

## Features

- ✅ StatefulSet for ordered deployment
- ✅ Persistent storage for media files
- ✅ HPA for horizontal scaling
- ✅ VPA for vertical scaling
- ✅ Pod disruption budget
- ✅ Advanced resource monitoring
- ✅ Graceful shutdown handling

## Deployment

```bash
# Apply all Phase 2 resources
kubectl apply -f .

# Check StatefulSet status
kubectl get statefulset vlc-player-sts
kubectl get pvc -l app=vlc-player

# Check autoscaling
kubectl get hpa vlc-player-hpa
kubectl get vpa vlc-player-vpa

# Monitor scaling events
kubectl get events --sort-by=.metadata.creationTimestamp
```

## Monitoring

```bash
# Check resource usage
kubectl top pods -l app=vlc-player

# Check HPA status
kubectl describe hpa vlc-player-hpa

# Check VPA recommendations
kubectl describe vpa vlc-player-vpa

# Monitor persistent volumes
kubectl get pv,pvc
```