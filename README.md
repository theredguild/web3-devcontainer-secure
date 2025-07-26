# 🟡 SECURE - Production Ready Web3 DevContainer

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&template_repository=theredguild/web3-devcontainer-secure)
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/theredguild/web3-devcontainer-secure)

## 🚀 One-Click Deployment

Launch a production-ready Web3 development environment with comprehensive security tooling:

- **🚀 GitHub Codespaces**: Click the badge above or use the green "Code" button → "Create codespace"
- **🔧 Gitpod**: Click the Gitpod badge above for browser-based development
- **💻 Local VS Code**: Clone this repo and open with Dev Containers extension

## 🎯 Purpose
A **production-ready** Web3 development environment with **industry-standard security practices**. Designed for professional development, team projects, and production smart contract development with comprehensive security tooling.

## 🛡️ Security Level: **PRODUCTION STANDARD**

### Security Decisions & Rationale:

#### ✅ **Security Enhancements**
- **Non-root user**: Custom `devuser` with minimal privileges
- **Capability dropping**: `--cap-drop ALL` removes dangerous capabilities
- **No new privileges**: `--security-opt no-new-privileges:true`
- **Minimal capabilities**: Only `NET_BIND_SERVICE` and `SYS_PTRACE` for debugging
- **Security toolchain**: Slither, Mythril, Manticore for vulnerability detection
- **Secure defaults**: Hardened npm configuration, security linting

#### 🔒 **Production Safeguards**
- Comprehensive `.gitignore` preventing secret leaks
- Security guidelines and best practices documentation
- Automated security linting with Solhint
- Static analysis tools pre-installed
- Secure package management configuration

### 🔧 **Technical Specifications**

| Component | Choice | Rationale |
|-----------|--------|-----------|
| **Base Image** | `mcr.microsoft.com/devcontainers/javascript-node:1-20-bullseye` | Proven compatibility with cloud environments |
| **User** | `devuser` (custom non-root) | Isolated user with minimal system access |
| **Security** | Capability dropping + no-new-privileges | Prevents privilege escalation attacks |
| **Tools** | Full security suite (Slither, Mythril, Manticore) | Professional-grade vulnerability detection |
| **Extensions** | Security-focused (8 extensions) | Comprehensive security analysis in VS Code |
| **Network** | Standard with security monitoring | Production-ready networking setup |

### 🛠️ **Security Tools Included**

| Tool | Purpose | Usage |
|------|---------|-------|
| **Slither** | Static analysis | `slither .` |
| **Mythril** | Symbolic execution | `myth analyze contract.sol` |
| **Manticore** | Dynamic analysis | `manticore contract.sol` |
| **Solhint** | Linting & best practices | `solhint 'contracts/**/*.sol'` |
| **Foundry** | Testing & fuzzing | `forge test --fuzz-runs 1000` |
| **Hardhat** | Development & deployment | Full Ethereum toolchain |

### 🚀 **Compatibility**

✅ **GitHub Codespaces**: Fully tested and compatible  
✅ **Gitpod**: Works with all security features enabled  
✅ **Local VS Code**: Complete Dev Containers support  
✅ **CI/CD**: Ready for GitHub Actions integration  

### 📦 **Pre-installed Development Stack**

**Core Web3 Tools:**
- Foundry (Forge, Cast, Anvil) - Latest version
- Hardhat - Ethereum development environment
- OpenZeppelin Contracts - Secure contract library
- Ethers.js - Ethereum interaction library

**Security Analysis:**
- Slither - Static analysis for Solidity
- Mythril - Security analysis tool
- Manticore - Symbolic execution engine
- Crytic-Compile - Smart compilation support

**Development Tools:**
- Solhint - Solidity linting
- Prettier - Code formatting
- ESLint - JavaScript linting

### 🎨 **VS Code Extensions**

**Core Solidity:**
- `JuanBlanco.solidity` - Solidity language support
- `NomicFoundation.hardhat-solidity` - Hardhat integration

**Security Analysis:**
- `tintinweb.solidity-visual-auditor` - Visual security analysis
- `tintinweb.solidity-metrics` - Code complexity metrics
- `trailofbits.weaudit` - Security audit workflow

**Productivity:**
- `eamodio.gitlens` - Git visualization
- `streetsidesoftware.code-spell-checker` - Spell checking
- `ms-vscode.vscode-json` - JSON editing

### 🚀 **Quick Start**

1. **Clone/Fork this repository**
2. **GitHub Codespaces**: 
   ```
   Click "Code" → "Codespaces" → "Create codespace"
   ```
3. **Gitpod**: 
   ```
   https://gitpod.io/#https://github.com/your-repo
   ```
4. **Local VS Code**: 
   ```
   Open in VS Code with Dev Containers extension
   ```

### 🔄 **Post-Setup Workflow**

After container creation, the following happens automatically:

1. **Security tools installation** verification
2. **Hardhat project initialization** (if needed)
3. **Security linting configuration** setup
4. **Secure .gitignore creation** to prevent key leaks
5. **Security guidelines documentation** generation

### ⚡ **Development Workflow**

```bash
# 1. Write your smart contracts
# 2. Run security analysis
slither .

# 3. Run comprehensive tests
forge test --fuzz-runs 1000

# 4. Lint your code
solhint 'contracts/**/*.sol'

# 5. Deploy securely
npx hardhat run scripts/deploy.js --network testnet
```

### ⚠️ **Security Considerations**

**Perfect for:**
- Production smart contract development
- Team collaboration on sensitive projects
- Professional auditing workflows
- Enterprise development environments
- DeFi protocol development

**Security Features:**
- Prevents accidental private key commits
- Automated vulnerability scanning
- Secure package management
- Container-level privilege restrictions
- Comprehensive security toolchain

### 🔄 **When to Upgrade**

Consider upgrading to higher security tiers when:
- **[HARDENED](https://github.com/theredguild/web3-devcontainer-hardened)**: Enterprise compliance requirements
- **[AUDITOR](https://github.com/theredguild/web3-devcontainer-auditor)**: Security audit and analysis work
- **[ISOLATED](https://github.com/theredguild/web3-devcontainer-isolated)**: Working with untrusted or malicious code

### 🔄 **Alternative Tiers**

- **[MINIMAL](https://github.com/theredguild/web3-devcontainer-minimal)** - For learning and simple prototyping

📋 **[View All DevContainer Types](https://github.com/theredguild/web3-devcontainer-hub)** - Decision matrix and comparison

### 📚 **Documentation**

- `SECURITY.md` - Comprehensive security guidelines
- `.solhint.json` - Configured security linting rules
- `.gitignore` - Prevents accidental secret commits

---

*This configuration balances security with productivity, perfect for professional Web3 development teams.*