FROM mcr.microsoft.com/devcontainers/javascript-node:1-20-bookworm

# Create secure non-root user
RUN groupadd -r devuser && useradd -r -g devuser -m -d /home/devuser devuser

# Install security and development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    build-essential \
    python3-dev \
    libpython3-dev \
    python3-pip \
    python3-venv \
    ca-certificates \
    gnupg \
    lsb-release \
    libssl-dev \
    libffi-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Foundry (Forge, Cast, Anvil)
RUN curl -L https://foundry.paradigm.xyz | bash
ENV PATH="/root/.foundry/bin:${PATH}"
RUN foundryup

# Install Rust for additional security tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Setup virtual enviroment 
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install uv and Python security tools
RUN python3 -m pip install --no-cache-dir --upgrade uv && \
    uv tool install slither-analyzer && \
    uv tool install mythril && \
    uv tool install crytic-compile 

# Install Node.js security and Web3 tools
RUN npm install -g \
    hardhat \
    @openzeppelin/contracts \
    @nomiclabs/hardhat-ethers \
    @nomiclabs/hardhat-waffle \
    ethereum-waffle \
    chai \
    ethers \
    solhint \
    prettier \
    prettier-plugin-solidity

# Set up secure workspace permissions
RUN mkdir -p /workspace /home/devuser/.npm && \
    chown -R devuser:devuser /workspace /home/devuser/.npm

# Copy Foundry to system location for all users
RUN mkdir -p /usr/local/foundry/bin && \
    cp /root/.foundry/bin/* /usr/local/foundry/bin/ && \
    chmod +x /usr/local/foundry/bin/*

# Switch to non-root user
USER devuser
WORKDIR /workspace

# Set up user environment
RUN echo 'export PATH="/usr/local/foundry/bin:$PATH"' >> /home/devuser/.bashrc
