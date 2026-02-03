#!/bin/bash

# NVIDIA NIM Switch - VPS Deployment Script
# This script automates the deployment process on a VPS

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   NVIDIA NIM Switch - VPS Deployment                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}❌ Please do not run as root${NC}"
    exit 1
fi

# Function to print status
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    print_status "Detected OS: $OS"
else
    print_error "Cannot detect OS"
    exit 1
fi

# Update system
echo ""
echo "1️⃣  Updating system..."
sudo apt update && sudo apt upgrade -y
print_status "System updated"

# Install dependencies
echo ""
echo "2️⃣  Installing dependencies..."
sudo apt install -y python3.11 python3-pip curl git nginx certbot python3-certbot-nginx ufw
print_status "Dependencies installed"

# Install uv
echo ""
echo "3️⃣  Installing uv..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    print_status "uv installed"
else
    print_status "uv already installed"
fi

# Clone repository
echo ""
echo "4️⃣  Setting up application..."
APP_DIR="/opt/nvidia-nim-switch-python"

if [ -d "$APP_DIR" ]; then
    print_warning "Directory already exists. Updating..."
    cd "$APP_DIR"
    sudo git pull
else
    cd /opt
    sudo git clone https://github.com/bluehawana/nvidia-nim-switch-python.git
    cd "$APP_DIR"
fi

sudo chown -R $USER:$USER "$APP_DIR"
print_status "Repository cloned/updated"

# Install Python dependencies
echo ""
echo "5️⃣  Installing Python dependencies..."
uv sync
print_status "Python dependencies installed"

# Setup environment
echo ""
echo "6️⃣  Setting up environment..."
if [ ! -f .env ]; then
    cp .env.example .env
    print_warning "Created .env file - YOU MUST ADD YOUR NVIDIA_NIM_API_KEY!"
    echo ""
    read -p "Enter your NVIDIA NIM API Key: " api_key
    sed -i "s/NVIDIA_NIM_API_KEY=.*/NVIDIA_NIM_API_KEY=$api_key/" .env
    print_status "API key configured"
else
    print_status ".env file already exists"
fi

# Create systemd service
echo ""
echo "7️⃣  Creating systemd service..."
sudo tee /etc/systemd/system/nvidia-nim-switch.service > /dev/null <<EOF
[Unit]
Description=NVIDIA NIM Switch Proxy
After=network.target

[Service]
Type=simple
User=$USER
Group=$USER
WorkingDirectory=$APP_DIR
Environment="PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=$HOME/.local/bin/uv run python server.py --host 0.0.0.0 --port 8089
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable nvidia-nim-switch
print_status "Systemd service created"

# Setup firewall
echo ""
echo "8️⃣  Configuring firewall..."
sudo ufw --force enable
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
print_status "Firewall configured"

# Setup Nginx
echo ""
echo "9️⃣  Configuring Nginx..."
read -p "Enter your domain name (or press Enter to skip): " domain

if [ -n "$domain" ]; then
    sudo tee /etc/nginx/sites-available/nvidia-nim-switch > /dev/null <<EOF
server {
    listen 80;
    server_name $domain;

    location / {
        proxy_pass http://localhost:8089;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }
}
EOF

    sudo ln -sf /etc/nginx/sites-available/nvidia-nim-switch /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl restart nginx
    print_status "Nginx configured for $domain"
    
    # Setup SSL
    echo ""
    read -p "Setup SSL with Let's Encrypt? (y/n): " setup_ssl
    if [ "$setup_ssl" = "y" ]; then
        sudo certbot --nginx -d $domain --non-interactive --agree-tos --register-unsafely-without-email
        print_status "SSL certificate installed"
    fi
else
    print_warning "Skipping Nginx configuration"
fi

# Start service
echo ""
echo "🔟 Starting service..."
sudo systemctl start nvidia-nim-switch
sleep 3

if sudo systemctl is-active --quiet nvidia-nim-switch; then
    print_status "Service started successfully"
else
    print_error "Service failed to start. Check logs with: sudo journalctl -u nvidia-nim-switch -f"
    exit 1
fi

# Test deployment
echo ""
echo "🧪 Testing deployment..."
if curl -s http://localhost:8089/health | grep -q "healthy"; then
    print_status "Health check passed"
else
    print_warning "Health check failed"
fi

# Summary
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ✅ Deployment Complete!                                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Service Status:"
sudo systemctl status nvidia-nim-switch --no-pager | head -5
echo ""
echo "🌐 Access URLs:"
if [ -n "$domain" ]; then
    echo "   Web Interface: https://$domain/"
    echo "   API Endpoint: https://$domain/v1/messages"
else
    echo "   Web Interface: http://$(curl -s ifconfig.me):8089/"
    echo "   API Endpoint: http://$(curl -s ifconfig.me):8089/v1/messages"
fi
echo ""
echo "📝 Useful Commands:"
echo "   View logs: sudo journalctl -u nvidia-nim-switch -f"
echo "   Restart: sudo systemctl restart nvidia-nim-switch"
echo "   Stop: sudo systemctl stop nvidia-nim-switch"
echo "   Status: sudo systemctl status nvidia-nim-switch"
echo ""
echo "⚠️  Important:"
echo "   - Make sure your NVIDIA_NIM_API_KEY is set in .env"
echo "   - Configure rate limits in .env for trial users"
echo "   - Monitor usage and costs"
echo ""
