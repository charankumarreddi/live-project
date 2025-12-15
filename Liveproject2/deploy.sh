#!/bin/bash

echo "========================================"
echo "  VLC Player Kubernetes Deployment"
echo "  Multi-Phase Implementation"
echo "========================================"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    print_status $BLUE "Checking prerequisites..."
    
    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        print_status $RED "Error: kubectl is not installed"
        exit 1
    fi
    
    # Check cluster connectivity
    if ! kubectl cluster-info &> /dev/null; then
        print_status $RED "Error: Cannot connect to Kubernetes cluster"
        exit 1
    fi
    
    # Check Docker (optional)
    if command -v docker &> /dev/null; then
        print_status $GREEN "Docker found - container images can be built locally"
    else
        print_status $YELLOW "Docker not found - using pre-built images"
    fi
    
    print_status $GREEN "Prerequisites check completed"
}

# Function to display menu
show_menu() {
    echo ""
    print_status $BLUE "Available Deployment Phases:"
    echo "1) Phase 1: DaemonSet & Basic Application"
    echo "2) Phase 2: StatefulSet & Autoscaling"
    echo "3) Phase 3: Operators & Advanced Features"
    echo "4) Build Docker Images"
    echo "5) Deploy All Phases (Sequential)"
    echo "6) Clean Up All Deployments"
    echo "7) Show Project Status"
    echo "8) Exit"
    echo ""
}

# Function to build Docker images
build_docker_images() {
    print_status $BLUE "Building Docker images..."
    
    if ! command -v docker &> /dev/null; then
        print_status $RED "Error: Docker is required to build images"
        return 1
    fi
    
    cd docker/
    
    # Build Linux image
    print_status $YELLOW "Building VLC Player Linux image..."
    docker build -t vlc-player:latest .
    
    # Note: Windows image would require Windows Docker host
    print_status $YELLOW "Note: Windows image requires Windows Docker host"
    print_status $YELLOW "For Windows support, build on Windows node with:"
    print_status $YELLOW "docker build -t vlc-player-windows:latest -f Dockerfile.windows ."
    
    cd ..
    print_status $GREEN "Docker images built successfully"
}

# Function to deploy Phase 1
deploy_phase1() {
    print_status $BLUE "Deploying Phase 1: DaemonSet & Basic Application..."
    cd phase1-daemonset/
    ./deploy.sh
    cd ..
    print_status $GREEN "Phase 1 deployment completed"
}

# Function to deploy Phase 2
deploy_phase2() {
    print_status $BLUE "Deploying Phase 2: StatefulSet & Autoscaling..."
    cd phase2-statefulset/
    ./deploy.sh
    cd ..
    print_status $GREEN "Phase 2 deployment completed"
}

# Function to deploy Phase 3
deploy_phase3() {
    print_status $BLUE "Deploying Phase 3: Operators & Advanced Features..."
    cd phase3-operators/
    ./deploy.sh
    cd ..
    print_status $GREEN "Phase 3 deployment completed"
}

# Function to deploy all phases
deploy_all() {
    print_status $BLUE "Deploying all phases sequentially..."
    
    # Check if user wants to build images first
    read -p "Build Docker images first? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        build_docker_images
    fi
    
    print_status $YELLOW "Starting Phase 1..."
    deploy_phase1
    
    print_status $YELLOW "Waiting 30 seconds before Phase 2..."
    sleep 30
    
    print_status $YELLOW "Starting Phase 2..."
    deploy_phase2
    
    print_status $YELLOW "Waiting 30 seconds before Phase 3..."
    sleep 30
    
    print_status $YELLOW "Starting Phase 3..."
    deploy_phase3
    
    print_status $GREEN "All phases deployed successfully!"
    show_project_status
}

# Function to clean up all deployments
cleanup_all() {
    print_status $YELLOW "Cleaning up all deployments..."
    
    read -p "Are you sure you want to delete all VLC Player deployments? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        
        print_status $YELLOW "Cleaning up Phase 3..."
        kubectl delete -f phase3-operators/examples/ 2>/dev/null || true
        kubectl delete -f phase3-operators/operator/ 2>/dev/null || true
        kubectl delete -f phase3-operators/rbac/ 2>/dev/null || true
        kubectl delete -f phase3-operators/crds/ 2>/dev/null || true
        
        print_status $YELLOW "Cleaning up Phase 2..."
        kubectl delete -f phase2-statefulset/ 2>/dev/null || true
        
        print_status $YELLOW "Cleaning up Phase 1..."
        kubectl delete -f phase1-daemonset/ 2>/dev/null || true
        
        print_status $GREEN "Cleanup completed"
    else
        print_status $YELLOW "Cleanup cancelled"
    fi
}

# Function to show project status
show_project_status() {
    print_status $BLUE "Project Status Overview:"
    
    echo ""
    print_status $YELLOW "=== Phase 1: DaemonSet ==="
    kubectl get daemonset -l app=vlc-player 2>/dev/null || echo "No DaemonSet found"
    
    echo ""
    print_status $YELLOW "=== Phase 2: StatefulSet ==="
    kubectl get statefulset -l app=vlc-player 2>/dev/null || echo "No StatefulSet found"
    kubectl get hpa -l app=vlc-player 2>/dev/null || echo "No HPA found"
    
    echo ""
    print_status $YELLOW "=== Phase 3: Operators ==="
    kubectl get deployment vlc-operator -n vlc-system 2>/dev/null || echo "No Operator found"
    kubectl get vlcplayer 2>/dev/null || echo "No VLCPlayer CRs found"
    
    echo ""
    print_status $YELLOW "=== All VLC Player Pods ==="
    kubectl get pods -l app=vlc-player -o wide 2>/dev/null || echo "No VLC Player pods found"
    
    echo ""
    print_status $YELLOW "=== Services ==="
    kubectl get services -l app=vlc-player 2>/dev/null || echo "No VLC Player services found"
    
    echo ""
    print_status $YELLOW "=== Persistent Volumes ==="
    kubectl get pvc -l app=vlc-player 2>/dev/null || echo "No PVCs found"
}

# Main execution
main() {
    check_prerequisites
    
    while true; do
        show_menu
        read -p "Select an option (1-8): " choice
        
        case $choice in
            1)
                deploy_phase1
                ;;
            2)
                deploy_phase2
                ;;
            3)
                deploy_phase3
                ;;
            4)
                build_docker_images
                ;;
            5)
                deploy_all
                ;;
            6)
                cleanup_all
                ;;
            7)
                show_project_status
                ;;
            8)
                print_status $GREEN "Goodbye!"
                exit 0
                ;;
            *)
                print_status $RED "Invalid option. Please try again."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main function
main