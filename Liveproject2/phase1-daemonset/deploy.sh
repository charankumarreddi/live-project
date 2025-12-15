#!/bin/bash

echo "=== Phase 1: DaemonSet Deployment ==="
echo "Deploying VLC Player with DaemonSet..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed or not in PATH"
    exit 1
fi

# Check cluster connectivity
if ! kubectl cluster-info &> /dev/null; then
    echo "Error: Unable to connect to Kubernetes cluster"
    exit 1
fi

# Apply configurations in order
echo "1. Creating ConfigMap..."
kubectl apply -f configmap.yaml

echo "2. Creating Secret..."
kubectl apply -f secret.yaml

echo "3. Creating DaemonSet..."
kubectl apply -f daemonset.yaml

echo "4. Creating Services..."
kubectl apply -f service.yaml

# Wait for deployment
echo "5. Waiting for DaemonSet to be ready..."
kubectl rollout status daemonset/vlc-player-ds --timeout=300s

# Display status
echo ""
echo "=== Deployment Status ==="
kubectl get daemonset vlc-player-ds
echo ""
kubectl get pods -l app=vlc-player
echo ""
kubectl get services -l app=vlc-player

echo ""
echo "=== Access Information ==="
echo "NodePort Service: http://<node-ip>:30080"
echo "LoadBalancer Service:"
LB_IP=$(kubectl get svc vlc-player-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
if [ -n "$LB_IP" ]; then
    echo "  External IP: http://$LB_IP"
else
    echo "  Waiting for LoadBalancer IP..."
fi

echo ""
echo "=== Useful Commands ==="
echo "Check logs: kubectl logs -l app=vlc-player -f"
echo "Check resources: kubectl top pods -l app=vlc-player"
echo "Describe pods: kubectl describe pods -l app=vlc-player"
echo "Delete deployment: kubectl delete -f ."