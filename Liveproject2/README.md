# VLC Player Kubernetes Deployment Project

This project demonstrates a comprehensive Kubernetes deployment of a VLC Player application across three progressive phases:

## Project Structure

```
Liveproject2/
├── README.md
├── docker/                    # Docker configurations
├── phase1-daemonset/         # Phase 1: Basic DaemonSet deployment
├── phase2-statefulset/       # Phase 2: StatefulSet with autoscaling
├── phase3-operators/         # Phase 3: Custom operators and CRDs
└── monitoring/               # Monitoring and observability
```

## Phases Overview

### Phase 1: DaemonSet & Basic Application
- **DaemonSet**: Ensures VLC Player runs on every node
- **Secrets**: Private license key management
- **ConfigMaps**: Playlist and configuration settings
- **Health Probes**: Liveness and readiness checks
- **Resource Management**: CPU/Memory limits and requests

### Phase 2: StatefulSet & Autoscaling
- **StatefulSet**: Persistent storage and ordered deployment
- **PersistentVolumeClaims**: Media storage persistence
- **HPA**: Horizontal Pod Autoscaler for load-based scaling
- **VPA**: Vertical Pod Autoscaler for resource optimization
- **Advanced Monitoring**: Resource usage tracking

### Phase 3: Updates & Operators
- **Rolling Updates**: Zero-downtime deployment strategies
- **Rollback Strategy**: Safe deployment rollback mechanisms
- **Custom Operators**: Automated VLC Player management
- **CRDs**: Custom Resource Definitions for VLC configuration
- **Windows Support**: Windows 10/11 workload compatibility

## Quick Start

1. **Prerequisites**:
   ```bash
   kubectl cluster-info
   helm version
   docker --version
   ```

2. **Deploy Phase 1**:
   ```bash
   cd phase1-daemonset
   kubectl apply -f .
   ```

3. **Deploy Phase 2**:
   ```bash
   cd phase2-statefulset
   kubectl apply -f .
   ```

4. **Deploy Phase 3**:
   ```bash
   cd phase3-operators
   kubectl apply -f .
   ```

## Features

- ✅ Multi-platform support (Linux, Windows)
- ✅ Persistent media storage
- ✅ Auto-scaling capabilities
- ✅ Health monitoring and probes
- ✅ Secret and configuration management
- ✅ Custom operators for automation
- ✅ Rolling updates and rollbacks
- ✅ Resource optimization

## Monitoring

Access monitoring dashboards:
- Prometheus: `kubectl port-forward svc/prometheus 9090:9090`
- Grafana: `kubectl port-forward svc/grafana 3000:3000`

## Documentation

Each phase contains detailed README files with deployment instructions and architectural explanations.