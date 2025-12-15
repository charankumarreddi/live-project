#!/bin/bash

echo "=== Phase 3: Operators and Advanced Features Deployment ==="
echo "Deploying VLC Player Operator with CRDs and Windows support..."

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

# Function to wait for CRD to be established
wait_for_crd() {
    local crd_name=$1
    echo "Waiting for CRD $crd_name to be established..."
    
    for i in {1..30}; do
        if kubectl get crd "$crd_name" -o jsonpath='{.status.conditions[?(@.type=="Established")].status}' 2>/dev/null | grep -q "True"; then
            echo "CRD $crd_name is established"
            return 0
        fi
        echo "Waiting for CRD $crd_name... ($i/30)"
        sleep 2
    done
    
    echo "Warning: CRD $crd_name did not become established within timeout"
    return 1
}

# Apply configurations in order
echo "1. Installing Custom Resource Definitions..."
kubectl apply -f crds/vlcplayer-crd.yaml
kubectl apply -f crds/vlcplaylist-crd.yaml

# Wait for CRDs to be established
wait_for_crd "vlcplayers.media.example.com"
wait_for_crd "vlcplaylists.media.example.com"

echo "2. Creating RBAC resources..."
kubectl apply -f rbac/rbac.yaml

echo "3. Creating webhook certificates..."
# Create a simple self-signed certificate for the webhook
kubectl create secret tls webhook-server-certs \
    --cert=<(openssl req -x509 -newkey rsa:4096 -keyout /dev/stdout -out /dev/stdout -days 365 -nodes -subj "/CN=vlc-operator-webhook-service.vlc-system.svc") \
    --key=<(openssl req -x509 -newkey rsa:4096 -keyout /dev/stdout -out /dev/stdout -days 365 -nodes -subj "/CN=vlc-operator-webhook-service.vlc-system.svc" | tail -n +2) \
    -n vlc-system 2>/dev/null || echo "Certificate secret already exists"

echo "4. Deploying VLC Operator..."
kubectl apply -f operator/deployment.yaml

# Wait for operator deployment
echo "5. Waiting for operator to be ready..."
kubectl rollout status deployment/vlc-operator -n vlc-system --timeout=300s

# Display operator status
echo ""
echo "=== Operator Status ==="
kubectl get deployment vlc-operator -n vlc-system
kubectl get pods -n vlc-system -l app=vlc-operator

echo ""
echo "=== Custom Resource Definitions ==="
kubectl get crd | grep media.example.com

echo ""
echo "=== Example Usage ==="
echo "Creating example VLC Player instances..."
kubectl apply -f examples/vlcplayer-examples.yaml

# Wait a moment for the operator to process
sleep 5

echo ""
echo "=== VLC Player Instances ==="
kubectl get vlcplayer
kubectl get vlcplaylist

echo ""
echo "=== Windows Node Check ==="
WINDOWS_NODES=$(kubectl get nodes -l kubernetes.io/os=windows --no-headers 2>/dev/null | wc -l)
if [ "$WINDOWS_NODES" -gt 0 ]; then
    echo "Found $WINDOWS_NODES Windows node(s) - Windows workloads supported"
    kubectl get nodes -l kubernetes.io/os=windows
else
    echo "No Windows nodes found - Windows workloads will remain pending"
    echo "To add Windows support, add Windows nodes to your cluster"
fi

echo ""
echo "=== Useful Commands ==="
echo "Check operator logs: kubectl logs -f deployment/vlc-operator -n vlc-system"
echo "List VLC Players: kubectl get vlcplayer"
echo "Describe VLC Player: kubectl describe vlcplayer vlc-player-linux"
echo "List Playlists: kubectl get vlcplaylist"
echo "Update replicas: kubectl patch vlcplayer vlc-player-linux --type='merge' -p='{\"spec\":{\"replicas\":5}}'"
echo "Delete VLC Player: kubectl delete vlcplayer vlc-player-linux"
echo ""
echo "=== Rolling Update Example ==="
echo "kubectl patch vlcplayer vlc-player-linux --type='merge' -p='{\"spec\":{\"version\":\"3.0.19\"}}'"
echo ""
echo "=== Cleanup ==="
echo "kubectl delete -f examples/"
echo "kubectl delete -f operator/"
echo "kubectl delete -f rbac/"
echo "kubectl delete -f crds/"