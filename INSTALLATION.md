# Installation Guide

cc-nvd-python (Enhanced NVIDIA NIM Manager) can be installed in several ways depending on your preference and system.

## One-Line Installation (Recommended)

For the quickest installation, use our one-line installer:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/cc-nvd-python/main/scripts/install.sh | bash
```

This will:
1. Install `uv` (Python package manager) if not already present
2. Download and install cc-nvd-python to `~/.cc-nvd-python`
3. Add `cc-nvd` command to your PATH

## PyPI Installation

Install directly from PyPI:

```bash
pip install cc-nvd-python
```

## Homebrew Installation (macOS)

If you're on macOS and prefer using Homebrew:

```bash
brew tap yourusername/cc-nvd-python
brew install cc-nvd-python
```

## Manual Installation

For manual installation or development:

```bash
# Clone the repository
git clone https://github.com/yourusername/cc-nvd-python.git
cd cc-nvd-python

# Install dependencies (requires uv)
uv sync --frozen

# Start the server
uv run uvicorn server:app --host 0.0.0.0 --port 8089
```

## Usage

After installation, you can use cc-nvd-python with these commands:

```bash
# Start the server
cc-nvd serve

# Run tests
cc-nvd test

# Run the demo
cc-nvd demo

# Run any Python script in the cc-nvd environment
cc-nvd your_script.py
```

## Prerequisites

- Python 3.10 or higher
- Git (for cloning the repository)
- curl (for the one-line installer)

The installation script will automatically install `uv` (a fast Python package manager) if it's not already present on your system.

## Post-Installation Setup

After installation:
1. Visit [NVIDIA Build](https://build.nvidia.com/explore/discover) to get your API key
2. Configure your NVIDIA NIM API key in the `.env` file:
   ```
   NVIDIA_NIM_API_KEY=your_nvidia_api_key_here
   ```
3. Start the server with `cc-nvd serve`
4. Access the web interface at `http://localhost:8089/`
5. Access the API documentation at `http://localhost:8089/docs`

## Updating

To update cc-nvd-python:

```bash
# If installed with one-line installer
cd ~/.cc-nvd-python && git pull

# If installed with pip
pip install --upgrade cc-nvd-python

# If installed with Homebrew
brew upgrade cc-nvd-python
```