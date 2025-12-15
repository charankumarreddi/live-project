# 🎥 VLC Player Kubernetes Deployment Project

## 📋 Project Overview

This comprehensive Kubernetes project demonstrates the deployment of a VLC Player application through three progressive phases, showcasing modern container orchestration patterns, autoscaling, and custom operators.

## 🏗️ Architecture Phases

### Phase 1: DaemonSet & Basic Application
```
DaemonSet → Pod (VLC PLAYER) → Running State
├── CPU/Memory Management
├── Liveness & Readiness Probes  
├── Secrets (Private License Key)
└── ConfigMaps (Playlist Settings)
```

### Phase 2: StatefulSet & Autoscaling
```
StatefulSet → Pod Management → Persistent Storage
├── PersistentVolumeClaim → PersistentVolume
├── HPA (Horizontal Pod Autoscaler)
└── VPA (Vertical Pod Autoscaler)
```

### Phase 3: Updates & Operators
```
Custom Operators → CRDs → Automated Management
├── Rolling Updates & Rollback Strategy
├── VLCPlayer CRD
├── VLCPlaylist CRD
└── Windows 10/11 Workload Support
```

## 📁 Project Structure

```
Liveproject2/
├── 📄 README.md                    # This file
├── 🚀 deploy.sh                    # Master deployment script
├── 🐳 docker/                      # Container configurations
│   ├── Dockerfile                  # Linux VLC container
│   ├── Dockerfile.windows          # Windows VLC container
│   ├── docker-compose.yml          # Local development
│   ├── scripts/
│   │   ├── start-vlc.sh            # Linux startup script
│   │   └── start-vlc.ps1           # Windows startup script
│   └── config/                     # Application configuration
├── 📦 phase1-daemonset/             # Phase 1: Basic deployment
│   ├── README.md                   # Phase 1 documentation
│   ├── deploy.sh                   # Phase 1 deployment script
│   ├── configmap.yaml              # Configuration management
│   ├── secret.yaml                 # Sensitive data
│   ├── daemonset.yaml              # DaemonSet specification
│   └── service.yaml                # Service definitions
├── 📊 phase2-statefulset/           # Phase 2: Persistent & scaling
│   ├── README.md                   # Phase 2 documentation
│   ├── deploy.sh                   # Phase 2 deployment script
│   ├── configmap.yaml              # Advanced configuration
│   ├── statefulset.yaml            # StatefulSet specification
│   ├── service.yaml                # Service definitions
│   ├── hpa.yaml                    # Horizontal Pod Autoscaler
│   └── vpa.yaml                    # Vertical Pod Autoscaler
├── 🤖 phase3-operators/             # Phase 3: Advanced automation
│   ├── README.md                   # Phase 3 documentation
│   ├── deploy.sh                   # Phase 3 deployment script
│   ├── crds/                       # Custom Resource Definitions
│   │   ├── vlcplayer-crd.yaml      # VLCPlayer CRD
│   │   └── vlcplaylist-crd.yaml    # VLCPlaylist CRD
│   ├── rbac/                       # Role-based access control
│   │   └── rbac.yaml               # Operator permissions
│   ├── operator/                   # Operator deployment
│   │   └── deployment.yaml         # Operator controller
│   └── examples/                   # Usage examples
│       └── vlcplayer-examples.yaml # Sample VLCPlayer resources
└── 📈 monitoring/                   # Observability stack
    ├── README.md                   # Monitoring documentation
    ├── prometheus/                 # Metrics collection
    └── grafana/                    # Visualization dashboards
```

## 🚀 Quick Start

### Prerequisites
- Kubernetes cluster (v1.20+)
- kubectl configured
- Docker (optional, for building images)
- 4GB+ RAM available in cluster
- Storage provisioner configured

### 1. Clone and Navigate
```bash
cd "Liveproject2"
```

### 2. Interactive Deployment
```bash
./deploy.sh
```

### 3. Manual Phase Deployment
```bash
# Phase 1: Basic DaemonSet
cd phase1-daemonset && ./deploy.sh

# Phase 2: StatefulSet with Autoscaling  
cd ../phase2-statefulset && ./deploy.sh

# Phase 3: Custom Operators
cd ../phase3-operators && ./deploy.sh
```

## 🎯 Key Features

### ✅ Phase 1 Features
- **DaemonSet**: Ensures VLC runs on every node
- **ConfigMaps**: Centralized configuration management
- **Secrets**: Secure credential storage
- **Health Probes**: Automated health monitoring
- **Resource Limits**: CPU/Memory constraints
- **LoadBalancer**: External access via cloud LB

### ✅ Phase 2 Features
- **StatefulSet**: Ordered deployment with persistent identity
- **Persistent Storage**: Media file persistence across restarts
- **HPA**: CPU/Memory-based horizontal scaling (2-10 replicas)
- **VPA**: Automatic resource optimization
- **Pod Disruption Budget**: High availability assurance
- **Init Containers**: Automatic media file provisioning

### ✅ Phase 3 Features
- **Custom Operators**: Automated VLC Player management
- **CRDs**: Declarative VLC configuration via Kubernetes API
- **Rolling Updates**: Zero-downtime deployments
- **Rollback Strategy**: Safe deployment rollback mechanisms
- **Windows Support**: Mixed Linux/Windows cluster compatibility
- **GitOps Ready**: Declarative configuration management

## 🖥️ Platform Support

### Linux Workloads
- Ubuntu 22.04 base images
- Resource-optimized containers
- Full feature support

### Windows Workloads
- Windows Server Core 2022
- Chocolatey package management
- PowerShell automation scripts
- Windows 10/11 node compatibility

## 📊 Monitoring & Observability

### Metrics Collection
- Prometheus integration
- Custom VLC Player metrics
- Resource usage tracking
- Performance monitoring

### Health Monitoring
- Liveness probes (HTTP /requests/status.xml)
- Readiness probes with startup delays
- Health check intervals (30s)
- Automatic restart on failures

## 🔧 Configuration Options

### VLC Player Settings
```yaml
spec:
  replicas: 3
  version: "3.0.18"
  platform: "linux" | "windows"
  resources:
    limits: { cpu: "2000m", memory: "2Gi" }
    requests: { cpu: "500m", memory: "512Mi" }
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
```

### Storage Configuration
```yaml
storage:
  enabled: true
  size: "20Gi"
  storageClass: "fast-ssd"
  accessMode: "ReadWriteOnce"
```

## 🔐 Security Features

- **Non-root containers**: Security-hardened execution
- **RBAC**: Fine-grained operator permissions
- **Secret management**: Encrypted credential storage
- **Security contexts**: Pod and container security policies
- **Network policies**: Traffic segmentation (optional)

## 📈 Scalability

### Horizontal Scaling
- **Min Replicas**: 2 (high availability)
- **Max Replicas**: 10 (load distribution)
- **CPU Target**: 70% utilization
- **Memory Target**: 80% utilization
- **Scale-down stabilization**: 5-minute window

### Vertical Scaling
- **Auto CPU/Memory optimization**
- **Quality of Service management**
- **Resource recommendation engine**
- **Update mode**: Auto/Initial/Off

## 🎬 Usage Examples

### Creating a VLC Player Instance
```bash
kubectl apply -f - <<EOF
apiVersion: media.example.com/v1
kind: VLCPlayer
metadata:
  name: my-vlc-player
spec:
  replicas: 3
  platform: linux
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 8
EOF
```

### Managing Playlists
```bash
kubectl apply -f - <<EOF
apiVersion: media.example.com/v1
kind: VLCPlaylist
metadata:
  name: my-playlist
spec:
  name: "Demo Playlist"
  items:
  - title: "Sample Video"
    url: "http://example.com/video.mp4"
  autoPlay: true
  loop: true
EOF
```

## 🔄 Update Strategies

### Rolling Updates
- **Zero-downtime deployments**
- **Health check integration**
- **Automatic rollback on failures**
- **Configurable update pace**

### Manual Operations
```bash
# Scale replicas
kubectl scale vlcplayer my-vlc-player --replicas=5

# Update version
kubectl patch vlcplayer my-vlc-player --type='merge' \
  -p='{"spec":{"version":"3.0.19"}}'

# Check status
kubectl get vlcplayer my-vlc-player -o yaml
```

## 🧹 Cleanup

### Individual Phases
```bash
# Clean specific phase
kubectl delete -f phase1-daemonset/
kubectl delete -f phase2-statefulset/
kubectl delete -f phase3-operators/
```

### Complete Cleanup
```bash
./deploy.sh  # Select option 6 for complete cleanup
```

## 🐛 Troubleshooting

### Common Issues
1. **LoadBalancer pending**: Check cloud provider LB provisioning
2. **VPA not working**: Ensure VPA is installed in cluster
3. **Windows pods pending**: Verify Windows nodes available
4. **Storage issues**: Check StorageClass configuration

### Debug Commands
```bash
# Check pod status
kubectl get pods -l app=vlc-player -o wide

# View logs
kubectl logs -l app=vlc-player -f

# Describe resources
kubectl describe vlcplayer my-vlc-player

# Check operator logs
kubectl logs -f deployment/vlc-operator -n vlc-system
```

## 📚 Documentation

Each phase includes detailed README files:
- **phase1-daemonset/README.md**: DaemonSet implementation details
- **phase2-statefulset/README.md**: StatefulSet and autoscaling guide
- **phase3-operators/README.md**: Operator pattern and CRD usage

## 🤝 Contributing

This project serves as a comprehensive example of Kubernetes deployment patterns. Feel free to extend it with additional features like:
- Service mesh integration
- Advanced monitoring dashboards
- Multi-cluster deployments
- GitOps workflows

## 📜 License

This project is provided as-is for educational and demonstration purposes.