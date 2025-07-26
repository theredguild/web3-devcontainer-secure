#!/bin/bash
# Individual DevContainer Testing Script
# Usage: ./test-individual-devcontainer.sh <devcontainer-name>
# Example: ./test-individual-devcontainer.sh web3-devcontainer-minimal

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMEOUT_BUILD=300
TIMEOUT_TEST=60

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if devcontainer name is provided
if [ $# -eq 0 ]; then
    error "Please provide a devcontainer name"
    echo "Usage: $0 <devcontainer-name>"
    echo "Available devcontainers:"
    ls -1 "$SCRIPT_DIR" | grep "web3-devcontainer-" | grep -v ".sh" || true
    exit 1
fi

DEVCONTAINER_NAME="$1"
DEVCONTAINER_PATH="$SCRIPT_DIR/$DEVCONTAINER_NAME"

# Validate devcontainer exists
if [ ! -d "$DEVCONTAINER_PATH" ]; then
    error "DevContainer directory not found: $DEVCONTAINER_PATH"
    exit 1
fi

if [ ! -f "$DEVCONTAINER_PATH/.devcontainer/devcontainer.json" ]; then
    error "devcontainer.json not found in $DEVCONTAINER_PATH/.devcontainer/"
    exit 1
fi

log "Testing DevContainer: $DEVCONTAINER_NAME"
echo "========================================"

# Step 1: Validate JSON configuration
log "Step 1: Validating devcontainer.json"
if jq . "$DEVCONTAINER_PATH/.devcontainer/devcontainer.json" > /dev/null 2>&1; then
    success "devcontainer.json is valid JSON"
else
    error "devcontainer.json contains invalid JSON"
    exit 1
fi

# Step 2: Build the devcontainer
log "Step 2: Building devcontainer (timeout: ${TIMEOUT_BUILD}s)"
cd "$DEVCONTAINER_PATH"

BUILD_LOG="/tmp/devcontainer-build-$DEVCONTAINER_NAME.log"
if timeout "$TIMEOUT_BUILD" devcontainer build --workspace-folder . > "$BUILD_LOG" 2>&1; then
    success "DevContainer build successful"
    BUILD_SUCCESS=true
else
    error "DevContainer build failed"
    echo "Build log (last 20 lines):"
    tail -20 "$BUILD_LOG" || true
    BUILD_SUCCESS=false
fi

# Step 3: Start and test the devcontainer (only if build succeeded)
if [ "$BUILD_SUCCESS" = true ]; then
    log "Step 3: Starting and testing devcontainer"
    
    # Start the container
    START_LOG="/tmp/devcontainer-start-$DEVCONTAINER_NAME.log"
    CONTAINER_ID=""
    
    if timeout "$TIMEOUT_TEST" devcontainer up --workspace-folder . > "$START_LOG" 2>&1; then
        success "DevContainer started successfully"
        
        # Extract container ID from docker ps
        CONTAINER_ID=$(docker ps --format "table {{.ID}}\t{{.Image}}" | grep "$DEVCONTAINER_NAME" | head -1 | cut -f1)
        
        if [ -n "$CONTAINER_ID" ]; then
            log "Step 4: Testing basic functionality in container $CONTAINER_ID"
            
            # Test basic commands
            TESTS_PASSED=0
            TESTS_TOTAL=0
            
            # Test Node.js (if available)
            if docker exec "$CONTAINER_ID" which node > /dev/null 2>&1; then
                TESTS_TOTAL=$((TESTS_TOTAL + 1))
                if NODE_VERSION=$(docker exec "$CONTAINER_ID" node --version 2>/dev/null); then
                    success "Node.js: $NODE_VERSION"
                    TESTS_PASSED=$((TESTS_PASSED + 1))
                else
                    error "Node.js not working"
                fi
            fi
            
            # Test NPM (if available)
            if docker exec "$CONTAINER_ID" which npm > /dev/null 2>&1; then
                TESTS_TOTAL=$((TESTS_TOTAL + 1))
                if NPM_VERSION=$(docker exec "$CONTAINER_ID" npm --version 2>/dev/null); then
                    success "NPM: $NPM_VERSION"
                    TESTS_PASSED=$((TESTS_PASSED + 1))
                else
                    error "NPM not working"
                fi
            fi
            
            # Test Git (if available)
            if docker exec "$CONTAINER_ID" which git > /dev/null 2>&1; then
                TESTS_TOTAL=$((TESTS_TOTAL + 1))
                if GIT_VERSION=$(docker exec "$CONTAINER_ID" git --version 2>/dev/null); then
                    success "Git: $GIT_VERSION"
                    TESTS_PASSED=$((TESTS_PASSED + 1))
                else
                    error "Git not working"
                fi
            fi
            
            # Test Python (if available)
            if docker exec "$CONTAINER_ID" which python3 > /dev/null 2>&1; then
                TESTS_TOTAL=$((TESTS_TOTAL + 1))
                if PYTHON_VERSION=$(docker exec "$CONTAINER_ID" python3 --version 2>/dev/null); then
                    success "Python: $PYTHON_VERSION"
                    TESTS_PASSED=$((TESTS_PASSED + 1))
                else
                    error "Python not working"
                fi
            fi
            
            # Test PIP (if available)
            if docker exec "$CONTAINER_ID" which pip3 > /dev/null 2>&1; then
                TESTS_TOTAL=$((TESTS_TOTAL + 1))
                if PIP_VERSION=$(docker exec "$CONTAINER_ID" pip3 --version 2>/dev/null); then
                    success "PIP: $PIP_VERSION"
                    TESTS_PASSED=$((TESTS_PASSED + 1))
                else
                    error "PIP not working"
                fi
            fi
            
            # Test Docker (if available)
            if docker exec "$CONTAINER_ID" which docker > /dev/null 2>&1; then
                TESTS_TOTAL=$((TESTS_TOTAL + 1))
                if DOCKER_VERSION=$(docker exec "$CONTAINER_ID" docker --version 2>/dev/null); then
                    success "Docker: $DOCKER_VERSION"
                    TESTS_PASSED=$((TESTS_PASSED + 1))
                else
                    error "Docker not working"
                fi
            fi
            
            # Check VS Code extensions (if devcontainer.json has customizations)
            if jq -e '.customizations.vscode.extensions' "$DEVCONTAINER_PATH/.devcontainer/devcontainer.json" > /dev/null 2>&1; then
                EXTENSION_COUNT=$(jq -r '.customizations.vscode.extensions | length' "$DEVCONTAINER_PATH/.devcontainer/devcontainer.json")
                success "VS Code extensions configured: $EXTENSION_COUNT"
            fi
            
            log "Test Summary: $TESTS_PASSED/$TESTS_TOTAL tests passed"
            
        else
            error "Could not find running container"
        fi
    else
        error "DevContainer failed to start"
        echo "Start log (last 10 lines):"
        tail -10 "$START_LOG" || true
    fi
    
    # Step 5: Cleanup
    log "Step 5: Cleaning up"
    if [ -n "$CONTAINER_ID" ]; then
        if docker stop "$CONTAINER_ID" > /dev/null 2>&1; then
            success "Container stopped"
        fi
        if docker rm "$CONTAINER_ID" > /dev/null 2>&1; then
            success "Container removed"
        fi
    fi
    
    # Clean up any dangling containers
    docker ps -a --filter "ancestor=$(docker images --format "table {{.Repository}}:{{.Tag}}" | grep "$DEVCONTAINER_NAME" | head -1)" --format "{{.ID}}" | xargs -r docker rm -f > /dev/null 2>&1 || true
    
else
    warning "Skipping container tests due to build failure"
fi

# Final summary
echo "========================================"
if [ "$BUILD_SUCCESS" = true ] && [ "$TESTS_PASSED" -gt 0 ]; then
    success "DevContainer $DEVCONTAINER_NAME: PASSED"
    exit 0
elif [ "$BUILD_SUCCESS" = true ]; then
    warning "DevContainer $DEVCONTAINER_NAME: BUILD OK, NO TESTS"
    exit 0
else
    error "DevContainer $DEVCONTAINER_NAME: FAILED"
    exit 1
fi