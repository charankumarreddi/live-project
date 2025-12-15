# Monitoring & Observability

This directory contains monitoring, logging, and observability configurations for the VLC Player Kubernetes deployment.

## Components

### Prometheus
- Metrics collection and storage
- Custom VLC Player metrics
- Resource usage monitoring
- Alerting rules

### Grafana
- Visualization dashboards
- VLC Player performance metrics
- Infrastructure monitoring
- Custom alerts

### Logging
- Centralized log collection
- VLC Player application logs
- Kubernetes cluster logs
- Log aggregation and analysis

## Quick Start

```bash
# Install monitoring stack
kubectl apply -f prometheus/
kubectl apply -f grafana/

# Access Grafana dashboard
kubectl port-forward svc/grafana 3000:3000

# Access Prometheus
kubectl port-forward svc/prometheus 9090:9090
```

## Dashboards

- VLC Player Overview
- Resource Utilization
- Performance Metrics
- Error Rates and Logs