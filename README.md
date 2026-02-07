# NVIDIA NIM Switch

**Switch between 180+ NVIDIA NIM models in under 1 second!**

> **🎉 NEW: No Login Required!** Use `nim-claude` to start coding immediately with free NVIDIA NIM models. No Anthropic subscription, no authentication, no credit card needed!

```
Claude Code  ──→  Proxy (localhost:8089)  ──→  NVIDIA NIM
                       ↓
                  182 Models
                 Switch in <1s
                 NO LOGIN! 🚀
```

[![Tests](https://img.shields.io/badge/tests-23%2F23%20passing-brightgreen)]()
[![Python](https://img.shields.io/badge/python-3.10%2B-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()
[![Models](https://img.shields.io/badge/working%20models-113%2F182%20(62%25)-success)](docs/MODEL_COMPATIBILITY.md)

---

## 📊 Model Compatibility

**113 out of 182 models (62%) confirmed working!**

We've tested all 182 NVIDIA NIM models. See the full compatibility report:

👉 **[View Model Compatibility Report](docs/MODEL_COMPATIBILITY.md)**

**Quick Stats:**
- ✅ 113 working models
- ❌ 69 require paid tier or special access
- 🧪 Tested: February 4, 2026

**Top Working Models:**
- GLM-4.7, MiniMax M2.1 (reasoning & large)
- Llama 3.1/3.2 family (1B-8B)
- Gemma 2 family (2B-9B)
- Phi 3/3.5 family
- Mistral 7B, Qwen 2/2.5 family

---

## ✨ Features

- 🔄 **180+ models** - Access entire NVIDIA NIM catalog
- ⚡ **Sub-second switching** - Change models in <1s via web UI or API
- 🚀 **No login required** - Start coding immediately with `nim-claude`
- 🌐 **Beautiful interface** - Speed indicators (⚡🚀🐢), search, filters
- 🔌 **RESTful API** - Full model management API
- 🚀 **Production ready** - Docker, systemd, Nginx, SSL
- 💻 **Cross-platform** - Linux, Mac, Windows (WSL2)
- 💰 **100% Free** - No Anthropic subscription needed

---

## 🚀 Quick Start

### Windows Users (WSL2 Required)

```powershell
# 1. Install WSL2 (PowerShell as Admin)
wsl --install
# Reboot, then open "Ubuntu" from Start Menu

# 2. In Ubuntu terminal:
sudo apt update && sudo apt upgrade -y
sudo apt install git -y
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# 3. Clone and setup
cd ~
git clone https://github.com/bluehawana/nvidia-nim-switch-python.git
cd nvidia-nim-switch-python
cp .env.example .env
nano .env  # Add your NVIDIA API key

# 4. Install and run
uv sync
./scripts/install_global.sh
source ~/.bashrc
nim-start
```

**Get API Key**: https://build.nvidia.com/explore/discover

**Open in Windows browser**: http://localhost:8089/

📖 **Detailed guide**: [Windows Installation](docs/WINDOWS_INSTALLATION.md)

---

### Linux/Mac Users

```bash
# 1. Clone
git clone https://github.com/bluehawana/nvidia-nim-switch-python.git
cd nvidia-nim-switch-python

# 2. Setup
cp .env.example .env
nano .env  # Add your NVIDIA API key

# 3. Install uv (if needed)
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# 4. Install and run
uv sync
./scripts/install_global.sh
source ~/.bashrc
nim-start
```

**Get API Key**: https://build.nvidia.com/explore/discover

**Open browser**: http://localhost:8089/

**Start coding**: `nim-claude` (no login required!)

---

## 🎯 Usage

```bash
nim-start      # Start server
nim-stop       # Stop server
nim-status     # Check status
nim-web        # Open web interface
nim-claude     # Use with Claude Code (FREE - NO LOGIN!)
nim-switch     # Quick model switch
```

**💡 Two Ways to Use Claude Code:**

1. **Free NVIDIA NIM** (Recommended) - `nim-claude`
   - ✅ No login required - works immediately!
   - ✅ 180+ free models (GLM 4.7, MiniMax 2.1, Llama, etc.)
   - ✅ Perfect for learning, experimentation, backup

2. **Anthropic Subscription** - `claude`
   - 💰 Requires paid subscription + login
   - ✅ Official Claude models (Sonnet 4.5, Opus 4.6)
   - ✅ Higher rate limits

**See [Switching Between Free and Paid](docs/SWITCHING_BETWEEN_FREE_AND_PAID.md) for details.**

**Web Interface**: http://localhost:8089/

**API Endpoints**:
- `GET /v1/models` - List all models
- `GET /v1/models/current` - Get current model
- `POST /v1/models/switch` - Switch model

---

## 📖 Documentation

**Installation**:
- [Windows (WSL2)](docs/WINDOWS_INSTALLATION.md) - Complete WSL2 setup
- [Quick Start](docs/QUICK_START.md) - 5-minute guide

**Usage**:
- [User Guide](docs/USER_GUIDE.md) - Complete documentation
- [No Login Required](docs/NO_LOGIN_REQUIRED.md) - How we bypass authentication
- [Claude Code Integration](docs/USE_WITH_CLAUDE_CODE.md)
- [Switching Between Free and Paid](docs/SWITCHING_BETWEEN_FREE_AND_PAID.md)
- [Model Speed Guide](docs/MODEL_SPEED_GUIDE.md)

**Deployment**:
- [VPS Deployment](docs/VPS_DEPLOYMENT.md) - Production setup
- [Cloudflare Setup](docs/CLOUDFLARE_SETUP.md) - DNS & SSL

---

## 🐛 Troubleshooting

**Windows**: "sudo: command not found"
- You're in PowerShell/CMD, not WSL2
- Open "Ubuntu" from Start Menu

**"Command not found: uv"**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
```

**"Connection refused"**
```bash
nim-status  # Check if running
nim-start   # Start if needed
```

**More help**: See [Windows Guide](docs/WINDOWS_INSTALLATION.md) or [User Guide](docs/USER_GUIDE.md)

---

## 🙏 Attribution

**Discovered via**: [@Gorden_Sun's X.com post](https://x.com/Gorden_Sun/status/1871808558591299801) about NVIDIA's free APIs

**Learned from**: [cc-nim](https://github.com/Alishahryar1/cc-nim) by [@Alishahryar1](https://github.com/Alishahryar1) - Original Claude Code + NVIDIA NIM concept

**This project**: Independent enhancement with significant improvements:
- ✅ **No login required** - Discovered API-first mode bypass
- ✅ Web UI (vs manual .env editing)
- ✅ Instant switching (vs restart required)
- ✅ 180+ models with speed indicators
- ✅ Production deployment ready
- ✅ Comprehensive documentation
- ✅ 23 automated tests

See [ATTRIBUTION.md](ATTRIBUTION.md) for details.

---

## 📜 Disclaimer

- **Open source & non-profit** - Educational/research purposes
- **Not affiliated with NVIDIA** - Uses public NVIDIA NIM APIs
- **Independent project** - Inspired by cc-nim, built from scratch
- **Proper attribution** - Full credit to community contributors

Questions? [GitHub Issues](https://github.com/bluehawana/nvidia-nim-switch-python/issues)

---

## 📊 Stats

✅ 23/23 tests passing | 🌟 180+ models | ⚡ <1s switching | 📖 15+ guides | 🐳 Docker ready

---

## License

MIT License - See [LICENSE](LICENSE)

---

**Made with ❤️ for the open-source AI community**
