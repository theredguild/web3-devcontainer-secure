# DevContainer Testing Makefile
# Provides convenient commands for testing devcontainers locally

.PHONY: help test-all test-individual clean setup install-deps list

# Default target
help:
	@echo "🧪 DevContainer Testing Commands"
	@echo "================================="
	@echo ""
	@echo "Setup:"
	@echo "  make setup           - Install dependencies and make scripts executable"
	@echo "  make install-deps    - Install devcontainer CLI and other dependencies"
	@echo ""
	@echo "Testing:"
	@echo "  make test-all        - Test all devcontainers"
	@echo "  make test-individual CONTAINER=<name> - Test specific devcontainer"
	@echo "  make list            - List available devcontainers"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean           - Clean up Docker containers, images, and logs"
	@echo ""
	@echo "Examples:"
	@echo "  make test-individual CONTAINER=web3-devcontainer-minimal"
	@echo "  make test-all"

# Setup and dependencies
setup: install-deps
	@echo "🔧 Making scripts executable..."
	chmod +x test-individual-devcontainer.sh
	chmod +x test-all-devcontainers.sh
	@echo "✅ Setup complete!"

install-deps:
	@echo "📦 Installing dependencies..."
	@which docker > /dev/null || (echo "❌ Docker not found. Please install Docker first." && exit 1)
	@which devcontainer > /dev/null || (echo "Installing devcontainer CLI..." && npm install -g @devcontainers/cli)
	@which jq > /dev/null || (echo "Installing jq..." && sudo apt-get update && sudo apt-get install -y jq)
	@which bc > /dev/null || (echo "Installing bc..." && sudo apt-get update && sudo apt-get install -y bc)
	@echo "✅ Dependencies installed!"

# Testing commands
test-all: setup
	@echo "🧪 Testing all devcontainers..."
	./test-all-devcontainers.sh

test-individual: setup
	@if [ -z "$(CONTAINER)" ]; then \
		echo "❌ Please specify CONTAINER name:"; \
		echo "   make test-individual CONTAINER=web3-devcontainer-minimal"; \
		echo ""; \
		echo "Available containers:"; \
		make list; \
		exit 1; \
	fi
	@echo "🧪 Testing $(CONTAINER)..."
	./test-individual-devcontainer.sh $(CONTAINER)

list:
	@echo "📋 Available DevContainers:"
	@find . -maxdepth 1 -type d -name "web3-devcontainer-*" | sed 's|./||' | sort | sed 's/^/  /'

# Maintenance
clean:
	@echo "🧹 Cleaning up..."
	@echo "Stopping running devcontainers..."
	-docker ps --filter "name=*devcontainer*" --format "{{.ID}}" | xargs -r docker stop
	@echo "Removing devcontainer containers..."
	-docker ps -a --filter "name=*devcontainer*" --format "{{.ID}}" | xargs -r docker rm
	@echo "Removing devcontainer images..."
	-docker images --filter "reference=vsc-web3-devcontainer-*" --format "{{.ID}}" | xargs -r docker rmi -f
	@echo "Pruning unused containers and images..."
	-docker container prune -f
	-docker image prune -f
	@echo "Cleaning up test logs..."
	-rm -rf test-logs/
	-rm -f devcontainer-test-report-*.json
	-rm -f /tmp/devcontainer-*.log
	@echo "✅ Cleanup complete!"

# Advanced testing targets
test-minimal:
	@make test-individual CONTAINER=web3-devcontainer-minimal

test-secure:
	@make test-individual CONTAINER=web3-devcontainer-secure

test-auditor:
	@make test-individual CONTAINER=web3-devcontainer-auditor

test-hardened:
	@make test-individual CONTAINER=web3-devcontainer-hardened

test-isolated:
	@make test-individual CONTAINER=web3-devcontainer-isolated

# CI/CD simulation
ci-test: clean setup
	@echo "🤖 Running CI-style tests..."
	@echo "This simulates what happens in GitHub Actions"
	./test-all-devcontainers.sh

# Quick status check
status:
	@echo "📊 DevContainer Status"
	@echo "======================"
	@echo "Docker status:"
	@docker --version 2>/dev/null || echo "  ❌ Docker not available"
	@echo "DevContainer CLI status:"
	@devcontainer --version 2>/dev/null || echo "  ❌ DevContainer CLI not available"
	@echo "Available devcontainers:"
	@make list
	@echo "Running containers:"
	@docker ps --filter "name=*devcontainer*" --format "  {{.Names}} ({{.Status}})" 2>/dev/null || echo "  None"