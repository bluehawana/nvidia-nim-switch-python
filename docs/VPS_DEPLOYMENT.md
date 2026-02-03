# 🚀 VPS Deployment Guide

Deploy NVIDIA NIM Switch on your VPS to offer a free trial service.

---

## 🎯 Deployment Options

### Option 1: Docker Deployment (Recommended)
### Option 2: Direct Installation
### Option 3: Systemd Service

---

## 📋 Prerequisites

### VPS Requirements
- **OS**: Ubuntu 20.04+ or Debian 11+
- **RAM**: 2GB minimum (4GB recommended)
- **CPU**: 2 cores minimum
- **Storage**: 10GB minimum
- **Network**: Public IP address
- **Domain** (optional): For HTTPS setup

### Software Requirements
- Python 3.10+
- uv (Python package manager)
- Nginx (for reverse proxy)
- Certbot (for SSL/HTTPS)

---

## 🐳 Option 1: Docker Deployment (Easiest)

### Step 1: Create Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install uv
RUN pip install uv

# Copy project files
COPY . .

# Install dependencies
RUN uv sync --frozen

# Expose port
EXPOSE 8089

# Run server
CMD ["uv", "run", "python", "server.py", "--host", "0.0.0.0", "--port", "8089"]
```

### Step 2: Create docker-compose.yml

```yaml
version: '3.8'

services:
  nvidia-nim-switch:
    build: .
    ports:
      - "8089:8089"
    environment:
      - NVIDIA_NIM_API_KEY=${NVIDIA_NIM_API_KEY}
      - MODEL=nvidia/llama-3.1-nemotron-70b-instruct
    volumes:
      - ./config:/app/config
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8089/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### Step 3: Deploy

```bash
# On your VPS
git clone https://github.com/bluehawana/nvidia-nim-switch-python.git
cd nvidia-nim-switch-python

# Create .env file
echo "NVIDIA_NIM_API_KEY=your_key_here" > .env

# Build and run
docker-compose up -d

# Check logs
docker-compose logs -f
```

---

## 🔧 Option 2: Direct Installation

### Step 1: Connect to VPS

```bash
ssh user@your-vps-ip
```

### Step 2: Install Dependencies

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Python 3.11
sudo apt install -y python3.11 python3.11-venv python3-pip curl git

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
```

### Step 3: Clone and Setup

```bash
# Clone repository
cd /opt
sudo git clone https://github.com/bluehawana/nvidia-nim-switch-python.git
cd nvidia-nim-switch-python

# Set permissions
sudo chown -R $USER:$USER /opt/nvidia-nim-switch-python

# Install dependencies
uv sync

# Create .env file
cp .env.example .env
nano .env  # Add your NVIDIA_NIM_API_KEY
```

### Step 4: Test Run

```bash
# Test the server
uv run python server.py --host 0.0.0.0 --port 8089

# Test in another terminal
curl http://localhost:8089/health
```

---

## 🔄 Option 3: Systemd Service (Production)

### Step 1: Create Service File

```bash
sudo nano /etc/systemd/system/nvidia-nim-switch.service
```

Add this content:

```ini
[Unit]
Description=NVIDIA NIM Switch Proxy
After=network.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/nvidia-nim-switch-python
Environment="PATH=/opt/nvidia-nim-switch-python/.venv/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=/usr/local/bin/uv run python server.py --host 0.0.0.0 --port 8089
Restart=always
RestartSec=10

# Security
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/nvidia-nim-switch-python/config

[Install]
WantedBy=multi-user.target
```

### Step 2: Enable and Start Service

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service
sudo systemctl enable nvidia-nim-switch

# Start service
sudo systemctl start nvidia-nim-switch

# Check status
sudo systemctl status nvidia-nim-switch

# View logs
sudo journalctl -u nvidia-nim-switch -f
```

---

## 🌐 Nginx Reverse Proxy Setup

### Step 1: Install Nginx

```bash
sudo apt install -y nginx
```

### Step 2: Create Nginx Configuration

```bash
sudo nano /etc/nginx/sites-available/nvidia-nim-switch
```

Add this content:

```nginx
server {
    listen 80;
    server_name your-domain.com;  # Replace with your domain

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
    limit_req zone=api_limit burst=20 nodelay;

    # Logging
    access_log /var/log/nginx/nvidia-nim-switch-access.log;
    error_log /var/log/nginx/nvidia-nim-switch-error.log;

    location / {
        proxy_pass http://localhost:8089;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts for long-running requests
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }

    # Static files caching
    location /static/ {
        proxy_pass http://localhost:8089/static/;
        expires 1d;
        add_header Cache-Control "public, immutable";
    }
}
```

### Step 3: Enable Site

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/nvidia-nim-switch /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

---

## 🔒 SSL/HTTPS Setup with Let's Encrypt

### Step 1: Install Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
```

### Step 2: Get SSL Certificate

```bash
sudo certbot --nginx -d your-domain.com
```

### Step 3: Auto-renewal

```bash
# Test renewal
sudo certbot renew --dry-run

# Certbot will auto-renew via cron
```

---

## 🔐 Security Hardening

### 1. Firewall Setup

```bash
# Install UFW
sudo apt install -y ufw

# Allow SSH
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status
```

### 2. API Key Protection

```bash
# Secure .env file
sudo chmod 600 /opt/nvidia-nim-switch-python/.env
sudo chown www-data:www-data /opt/nvidia-nim-switch-python/.env
```

### 3. Rate Limiting (Already in Nginx config)

The Nginx config includes:
- 10 requests per second per IP
- Burst of 20 requests
- Automatic blocking of abusers

### 4. Add Authentication (Optional)

For a free trial, you might want to add basic auth:

```bash
# Install apache2-utils
sudo apt install -y apache2-utils

# Create password file
sudo htpasswd -c /etc/nginx/.htpasswd trial_user

# Update Nginx config
sudo nano /etc/nginx/sites-available/nvidia-nim-switch
```

Add to location block:
```nginx
auth_basic "NVIDIA NIM Switch Trial";
auth_basic_user_file /etc/nginx/.htpasswd;
```

---

## 📊 Monitoring Setup

### 1. Basic Monitoring Script

```bash
# Create monitoring script
sudo nano /opt/nvidia-nim-switch-python/monitor.sh
```

```bash
#!/bin/bash

# Check if service is running
if ! systemctl is-active --quiet nvidia-nim-switch; then
    echo "Service is down! Restarting..."
    systemctl restart nvidia-nim-switch
    # Send alert (optional)
fi

# Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "Warning: Disk usage is ${DISK_USAGE}%"
fi

# Check memory
MEM_USAGE=$(free | awk 'NR==2 {printf "%.0f", $3/$2*100}')
if [ $MEM_USAGE -gt 80 ]; then
    echo "Warning: Memory usage is ${MEM_USAGE}%"
fi
```

```bash
# Make executable
sudo chmod +x /opt/nvidia-nim-switch-python/monitor.sh

# Add to crontab (run every 5 minutes)
(crontab -l 2>/dev/null; echo "*/5 * * * * /opt/nvidia-nim-switch-python/monitor.sh") | crontab -
```

### 2. Log Rotation

```bash
sudo nano /etc/logrotate.d/nvidia-nim-switch
```

```
/var/log/nginx/nvidia-nim-switch-*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        systemctl reload nginx > /dev/null
    endscript
}
```

---

## 🎯 Free Trial Configuration

### 1. Usage Limits

Update `.env` to add trial limits:

```bash
# Rate limiting for trial users
NVIDIA_NIM_RATE_LIMIT=5
NVIDIA_NIM_RATE_WINDOW=60

# Max tokens for trial
NVIDIA_NIM_MAX_TOKENS=1000
```

### 2. Trial Landing Page

Create a simple landing page explaining the trial:

```bash
sudo nano /var/www/html/trial.html
```

```html
<!DOCTYPE html>
<html>
<head>
    <title>NVIDIA NIM Switch - Free Trial</title>
</head>
<body>
    <h1>🚀 NVIDIA NIM Switch - Free Trial</h1>
    <p>Try our AI model switching service for free!</p>
    
    <h2>Trial Limits:</h2>
    <ul>
        <li>5 requests per minute</li>
        <li>1000 tokens per request</li>
        <li>Access to all 182 models</li>
    </ul>
    
    <h2>Access:</h2>
    <ul>
        <li>Web Interface: <a href="/dashboard">Dashboard</a></li>
        <li>API Endpoint: https://your-domain.com/v1/messages</li>
    </ul>
    
    <h2>Documentation:</h2>
    <p><a href="https://github.com/bluehawana/nvidia-nim-switch-python">GitHub Repository</a></p>
</body>
</html>
```

---

## 🧪 Testing Deployment

### 1. Health Check

```bash
curl https://your-domain.com/health
```

### 2. API Test

```bash
curl -X POST https://your-domain.com/v1/messages \
  -H "Content-Type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 100,
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### 3. Web Interface

Open: https://your-domain.com/

---

## 📈 Scaling Considerations

### For More Users:

1. **Increase VPS Resources**
   - 4GB+ RAM
   - 4+ CPU cores
   - SSD storage

2. **Add Load Balancer**
   - Multiple instances
   - Nginx load balancing
   - Session persistence

3. **Add Caching**
   - Redis for rate limiting
   - Response caching

4. **Database for Analytics**
   - Track usage
   - Monitor performance
   - User management

---

## 💰 Cost Estimation

### VPS Costs (Monthly):
- **Basic** (2GB RAM, 2 CPU): $5-10/month
- **Standard** (4GB RAM, 4 CPU): $15-25/month
- **Premium** (8GB RAM, 8 CPU): $40-60/month

### Providers:
- DigitalOcean
- Linode
- Vultr
- Hetzner (cheapest)

### NVIDIA NIM API Costs:
- Check NVIDIA pricing
- Set usage limits for trial users

---

## 🎉 Quick Deploy Script

Save this as `deploy.sh`:

```bash
#!/bin/bash

echo "🚀 NVIDIA NIM Switch VPS Deployment"
echo "===================================="

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y python3.11 python3-pip curl git nginx certbot python3-certbot-nginx

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# Clone repository
cd /opt
sudo git clone https://github.com/bluehawana/nvidia-nim-switch-python.git
cd nvidia-nim-switch-python

# Setup
uv sync
cp .env.example .env

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file: sudo nano /opt/nvidia-nim-switch-python/.env"
echo "2. Add your NVIDIA_NIM_API_KEY"
echo "3. Setup systemd service (see VPS_DEPLOYMENT.md)"
echo "4. Configure Nginx (see VPS_DEPLOYMENT.md)"
echo "5. Setup SSL with certbot"
```

---

## 📚 Additional Resources

- [Nginx Documentation](https://nginx.org/en/docs/)
- [Let's Encrypt](https://letsencrypt.org/)
- [Systemd Service Guide](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [UFW Firewall](https://help.ubuntu.com/community/UFW)

---

**Ready to deploy your free trial service!** 🚀
