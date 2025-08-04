# Web3 DevContainer - Secure

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&template_repository=theredguild/web3-devcontainer-secure)
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/theredguild/web3-devcontainer-secure)

## What is this?

A production-ready Web3 development environment with built-in security tools and best practices. Suitable for professional development and team projects.

## What's inside?

**Development Tools:**
- Foundry (forge, cast, anvil)
- Hardhat (testing, deployment)
- Go (latest via asdf)
- Rust (latest via rustup)
- Python 3.12 with uv package manager

**Security Tools:**
- Slither (static analysis)
- Mythril (symbolic execution)
- Echidna (fuzzing)
- Solhint (security linting)

**Container Security:**
- Non-root user with minimal privileges
- Capability dropping
- Security-focused VS Code extensions

## When to use this?

- Production smart contract development
- Team collaboration projects
- Professional auditing workflows
- DeFi protocol development
- Any project handling real value

## How to use?

Click a badge above to launch instantly, or clone this repo and open in VS Code with the Dev Containers extension.

Run security analysis before deploying:
```bash
slither .                    # Static analysis
forge test --fuzz-runs 1000 # Comprehensive testing
solhint 'contracts/**/*.sol' # Security linting
echidna -c echidna.config.yaml # Fuzzing
myth analyze contract.sol # Symbolic execution
```

## Need something different?

Check the [Web3 DevContainer Hub](https://github.com/theredguild/web3-devcontainer-hub) for minimal, hardened, or specialized environments.