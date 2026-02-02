# cc-nvd-python (Enhanced NVIDIA NIM Manager)

Independent enhancement of NVIDIA NIM proxy with advanced model switching capabilities.

## 🌟 Enhanced Features

### 🔄 Advanced Model Switching
- Switch between 1,000+ NVIDIA NIM models on-the-fly via API or web interface
- Persistent model selection across server restarts
- No need to manually edit environment variables or restart services

### 🌐 Web Interface for NVIDIA NIM
- User-friendly web dashboard for browsing and selecting NVIDIA NIM models
- Search functionality to quickly find models
- Real-time model switching with visual feedback

### 🔌 NVIDIA NIM RESTful API
- `GET /v1/models` - List all available NVIDIA NIM models
- `GET /v1/models/current` - Get the currently selected NVIDIA NIM model
- `POST /v1/models/switch` - Switch to a different NVIDIA NIM model
- Full compatibility with NVIDIA NIM API specifications

### ⚡ Optimized for NVIDIA NIM
- Built specifically for NVIDIA NIM performance
- Supports all NVIDIA NIM parameters and features
- Optimized streaming responses for NVIDIA NIM

## Quick Start

### One-Line Installation
```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/cc-nvd-python/main/scripts/install.sh | bash
```

### Using pip
```bash
pip install cc-nvd-python
```

### Start the Server
```bash
cc-nvd serve
```

### Access
- Web Interface: http://localhost:8089/
- API Documentation: http://localhost:8089/docs
- Model Switching API: http://localhost:8089/v1/models

## Setup Your NVIDIA NIM API Key

1. Visit [NVIDIA Build](https://build.nvidia.com/explore/discover)
2. Generate your NVIDIA NIM API key
3. Configure your key in the `.env` file:
   ```
   NVIDIA_NIM_API_KEY=your_nvidia_api_key_here
   ```

## NVIDIA NIM Model Switching API

### List Available NVIDIA NIM Models
```bash
curl http://localhost:8089/v1/models
```

### Get Current NVIDIA NIM Model
```bash
curl http://localhost:8089/v1/models/current
```

### Switch NVIDIA NIM Models
```bash
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "nvidia/llama-3.1-nemotron-70b-instruct"}'
```

## Web Interface

Access the web interface at `http://localhost:8089/` to visually browse and switch between NVIDIA NIM models with a modern, responsive UI.

## Installation

See [INSTALLATION.md](INSTALLATION.md) for detailed installation instructions.

## Attribution

This is an **independent project** that draws inspiration from concepts in various AI proxy implementations. See [ATTRIBUTION.md](ATTRIBUTION.md) for details.

## Trademarks

NVIDIA and NVIDIA NIM are trademarks of NVIDIA Corporation. This project is not officially affiliated with or endorsed by NVIDIA.

## License

MIT