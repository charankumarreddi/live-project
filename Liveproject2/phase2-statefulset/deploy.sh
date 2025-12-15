#!/bin/bash

echo "=== Phase 2: StatefulSet with Autoscaling Deployment ==="
echo "Deploying VLC Player with StatefulSet, HPA, and VPA..."

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

# Check for metrics server
echo "Checking for metrics server..."
if ! kubectl get deployment metrics-server -n kube-system &> /dev/null; then
    echo "Warning: Metrics server not found. HPA and VPA require metrics server."
    echo "To install metrics server:"
    echo "kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
fi

# Check for VPA
echo "Checking for VPA..."
if ! kubectl get crd verticalpodautoscalers.autoscaling.k8s.io &> /dev/null; then
    echo "Warning: VPA CRDs not found. Installing VPA..."
    echo "VPA installation requires additional setup. Continuing without VPA for now."
    VPA_AVAILABLE=false
else
    VPA_AVAILABLE=true
fi

# Apply configurations in order
echo "1. Creating ConfigMap..."
kubectl apply -f configmap.yaml

echo "2. Creating Secret (if not exists)..."
kubectl apply -f ../phase1-daemonset/secret.yaml

echo "3. Creating StatefulSet..."
kubectl apply -f statefulset.yaml

echo "4. Creating Services..."
kubectl apply -f service.yaml

echo "5. Creating HPA..."
kubectl apply -f hpa.yaml

if [ "$VPA_AVAILABLE" = true ]; then
    echo "6. Creating VPA and PDB..."
    kubectl apply -f vpa.yaml
else
    echo "6. Skipping VPA (not available)"
    # Apply only PDB
    kubectl apply -f <(kubectl get -f vpa.yaml -o yaml | grep -A 20 "kind: PodDisruptionBudget")
fi

# Wait for deployment
echo "7. Waiting for StatefulSet to be ready..."
kubectl rollout status statefulset/vlc-player-sts --timeout=600s

# Display status
echo ""
echo "=== Deployment Status ==="
kubectl get statefulset vlc-player-sts
echo ""
kubectl get pods -l app=vlc-player,phase=statefulset
echo ""
kubectl get pvc -l app=vlc-player
echo ""
kubectl get services -l app=vlc-player,phase=statefulset

echo ""
echo "=== Autoscaling Status ==="
kubectl get hpa vlc-player-hpa
if [ "$VPA_AVAILABLE" = true ]; then
    kubectl get vpa vlc-player-vpa
fi
kubectl get pdb vlc-player-pdb

echo ""
echo "=== Access Information ==="
echo "NodePort Service: http://<node-ip>:30081"
echo "LoadBalancer Service:"
LB_IP=$(kubectl get svc vlc-player-sts-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
if [ -n "$LB_IP" ]; then
    echo "  External IP: http://$LB_IP"
else
    echo "  Waiting for LoadBalancer IP..."
fi

echo ""
echo "Individual Pod Access:"
for i in {0..2}; do
    echo "  vlc-player-sts-$i.vlc-player-headless-sts.default.svc.cluster.local:8080"
done

echo ""
echo "=== Useful Commands ==="
echo "Check logs: kubectl logs vlc-player-sts-0 -f"
echo "Check resources: kubectl top pods -l app=vlc-player"
echo "Check HPA: kubectl describe hpa vlc-player-hpa"
if [ "$VPA_AVAILABLE" = true ]; then
    echo "Check VPA: kubectl describe vpa vlc-player-vpa"
fi
echo "Check PVCs: kubectl get pvc -l app=vlc-player"
echo "Scale manually: kubectl scale statefulset vlc-player-sts --replicas=5"
echo "Delete deployment: kubectl delete -f ."