# 🚀 Deployment to models.bluehawana.com

Complete guide for deploying NVIDIA NIM Switch to your production domain.

---

## 🎯 Deployment Overview

**Domain**: models.bluehawana.com  
**Purpose**: Free trial service for NVIDIA NIM model switching  
**Features**: 
- Web interface for model browsing
- API endpoint for Claude Code integration
- Speed indicators and smart sorting
- Rate limiting for trial users

---

## 📋 Pre-Deployment Checklist

- [ ] VPS ready (Ubuntu 20.04+, 4GB RAM, 2 CPU cores)
- [ ] Domain DNS configured (A record pointing to VPS IP)
- [ ] NVIDIA NIM API key ready
- [ ] SSH access to VPS
- [ ] Sudo privileges on VPS

---

## 🚀 Quick Deployment

### One-Command Deploy

```bash
# SSH into your VPS
ssh user@your-vps-ip

# Run deployment script
curl -fsSL https://raw.githubusercontent.com/bluehawana/nvidia-nim-swtich-python/main/scripts/deploy_vps.sh | bash
```

When prompted:
- Domain: `models.bluehawana.com`
- API Key: Your NVIDIA NIM API key
- SSL: `y` (yes)

---

## 🔧 Manual Deployment Steps

### Step 1: DNS Configuration

Before deploying, ensure DNS is configured:

```bash
# Check DNS propagation
dig models.bluehawana.com

# Should show your VPS IP address
```

### Step 2: Connect to VPS

```bash
ssh user@your-vps-ip
```

### Step 3: Install Dependencies

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y \
    python3.11 \
    python3-pip \
    curl \
    git \
    nginx \
    certbot \
    python3-certbot-nginx \
    ufw

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
```

### Step 4: Clone Repository

```bash
# Clone to /opt
cd /opt
sudo git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
cd nvidia-nim-swtich-python

# Set permissions
sudo chown -R $USER:$USER /opt/nvidia-nim-swtich-python
```

### Step 5: Configure Environment

```bash
# Copy example env
cp .env.example .env

# Edit .env file
nano .env
```

Add your configuration:
```bash
# NVIDIA NIM API Key
NVIDIA_NIM_API_KEY=your_nvidia_api_key_here

# Model settings
MODEL=nvidia/llama-3.1-nemotron-70b-instruct

# Rate limiting for trial users
NVIDIA_NIM_RATE_LIMIT=10
NVIDIA_NIM_RATE_WINDOW=60

# Token limits
NVIDIA_NIM_MAX_TOKENS=2000

# Server settings
HOST=0.0.0.0
PORT=8089
```

### Step 6: Install Python Dependencies

```bash
uv sync
```

### Step 7: Create Systemd Service

```bash
sudo nano /etc/systemd/system/nvidia-nim-switch.service
```

Add this content:
```ini
[Unit]
Description=NVIDIA NIM Switch - models.bluehawana.com
After=network.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/nvidia-nim-swtich-python
Environment="PATH=/home/YOUR_USER/.local/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=/home/YOUR_USER/.local/bin/uv run python server.py --host 0.0.0.0 --port 8089
Restart=always
RestartSec=10

# Security
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/nvidia-nim-swtich-python/config

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable nvidia-nim-switch
sudo systemctl start nvidia-nim-switch
sudo systemctl status nvidia-nim-switch
```

### Step 8: Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/models.bluehawana.com
```

Add this configuration:
```nginx
# Rate limiting zones
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
limit_req_zone $binary_remote_addr zone=web_limit:10m rate=30r/s;

server {
    listen 80;
    server_name models.bluehawana.com;

    # Logging
    access_log /var/log/nginx/models.bluehawana.com-access.log;
    error_log /var/log/nginx/models.bluehawana.com-error.log;

    # API endpoints - stricter rate limiting
    location /v1/ {
        limit_req zone=api_limit burst=20 nodelay;
        
        proxy_pass http://localhost:8089;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Long timeouts for AI responses
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }

    # Web interface - more lenient rate limiting
    location / {
        limit_req zone=web_limit burst=50 nodelay;
        
        proxy_pass http://localhost:8089;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Static files with caching
    location /static/ {
        proxy_pass http://localhost:8089/static/;
        expires 7d;
        add_header Cache-Control "public, immutable";
    }

    # Health check endpoint (no rate limiting)
    location /health {
        proxy_pass http://localhost:8089/health;
        access_log off;
    }
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/models.bluehawana.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Step 9: Setup SSL with Let's Encrypt

```bash
sudo certbot --nginx -d models.bluehawana.com
```

Follow the prompts:
- Email: your-email@example.com
- Agree to terms: Yes
- Redirect HTTP to HTTPS: Yes (recommended)

### Step 10: Configure Firewall

```bash
# Enable UFW
sudo ufw enable

# Allow SSH
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Check status
sudo ufw status
```

---

## 🧪 Testing Deployment

### 1. Health Check

```bash
curl https://models.bluehawana.com/health
# Expected: {"status":"healthy"}
```

### 2. Web Interface

Open in browser: https://models.bluehawana.com/

You should see:
- ✅ NVIDIA NIM Model Switcher interface
- ✅ Current model display
- ✅ 182 models with speed indicators
- ✅ Sort and filter options

### 3. API Test

```bash
curl -X POST https://models.bluehawana.com/v1/messages \
  -H "Content-Type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 100,
    "messages": [
      {"role": "user", "content": "Hello! What model are you?"}
    ]
  }'
```

### 4. Model Switching Test

```bash
# Get current model
curl https://models.bluehawana.com/v1/models/current

# Switch model
curl -X POST https://models.bluehawana.com/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "meta/llama-3.1-8b-instruct"}'

# Verify switch
curl https://models.bluehawana.com/v1/models/current
```

---

## 📊 Monitoring & Maintenance

### View Logs

```bash
# Application logs
sudo journalctl -u nvidia-nim-switch -f

# Nginx access logs
sudo tail -f /var/log/nginx/models.bluehawana.com-access.log

# Nginx error logs
sudo tail -f /var/log/nginx/models.bluehawana.com-error.log
```

### Service Management

```bash
# Restart service
sudo systemctl restart nvidia-nim-switch

# Stop service
sudo systemctl stop nvidia-nim-switch

# Check status
sudo systemctl status nvidia-nim-switch

# View recent logs
sudo journalctl -u nvidia-nim-switch -n 100
```

### Update Application

```bash
cd /opt/nvidia-nim-swtich-python
sudo git pull
uv sync
sudo systemctl restart nvidia-nim-switch
```

---

## 🎯 Free Trial Configuration

### Trial Limits (Already in .env)

```bash
# 10 requests per minute per IP
NVIDIA_NIM_RATE_LIMIT=10
NVIDIA_NIM_RATE_WINDOW=60

# 2000 tokens max per request
NVIDIA_NIM_MAX_TOKENS=2000
```

### Usage Monitoring

Create a monitoring script:

```bash
sudo nano /opt/nvidia-nim-swtich-python/monitor_usage.sh
```

```bash
#!/bin/bash

# Monitor usage
echo "=== NVIDIA NIM Switch Usage Report ==="
echo "Date: $(date)"
echo ""

# Check service status
echo "Service Status:"
systemctl is-active nvidia-nim-switch && echo "✅ Running" || echo "❌ Stopped"
echo ""

# Count requests today
echo "Requests Today:"
grep "$(date +%d/%b/%Y)" /var/log/nginx/models.bluehawana.com-access.log | wc -l
echo ""

# Top IPs
echo "Top 10 IPs:"
grep "$(date +%d/%b/%Y)" /var/log/nginx/models.bluehawana.com-access.log | \
    awk '{print $1}' | sort | uniq -c | sort -rn | head -10
echo ""

# Disk usage
echo "Disk Usage:"
df -h / | tail -1
echo ""

# Memory usage
echo "Memory Usage:"
free -h | grep Mem
```

```bash
chmod +x /opt/nvidia-nim-swtich-python/monitor_usage.sh

# Run daily at 9 AM
(crontab -l 2>/dev/null; echo "0 9 * * * /opt/nvidia-nim-swtich-python/monitor_usage.sh") | crontab -
```

---

## 🌐 Promote Your Service

### Landing Page Content

Add to your main website:

```html
<section class="trial-service">
    <h2>🚀 Try NVIDIA NIM Switch - Free Trial</h2>
    <p>Switch between 180+ AI models in under 1 second!</p>
    
    <div class="features">
        <div class="feature">
            <h3>⚡ Speed Indicators</h3>
            <p>See which models are fast, medium, or slow</p>
        </div>
        <div class="feature">
            <h3>🔄 Instant Switching</h3>
            <p>Change models without restarting</p>
        </div>
        <div class="feature">
            <h3>🌐 Web Interface</h3>
            <p>Beautiful dashboard for model management</p>
        </div>
    </div>
    
    <a href="https://models.bluehawana.com" class="cta-button">
        Try Free Trial →
    </a>
</section>
```

### Social Media Posts

**Twitter/X**:
```
🚀 Just launched a free trial of NVIDIA NIM Switch!

✨ Features:
• 180+ AI models
• Sub-second switching
• Speed indicators
• Beautiful web UI

Try it now: https://models.bluehawana.com

#AI #MachineLearning #NVIDIA #OpenSource
```

**LinkedIn**:
```
Excited to announce the free trial of NVIDIA NIM Switch is now live!

🎯 What it does:
Switch between 180+ NVIDIA NIM models in under 1 second - 60x faster than traditional methods.

✨ Key features:
• Visual speed indicators (Fast/Medium/Slow)
• Smart sorting and filtering
• Claude API compatible
• Beautiful web interface

Perfect for developers who want to:
✓ Test different AI models quickly
✓ Find the fastest models for their use case
✓ Switch models without breaking workflow

Try the free trial: https://models.bluehawana.com

Built with Python, FastAPI, and NVIDIA NIM API.
Open source: https://github.com/bluehawana/nvidia-nim-swtich-python

#AI #MachineLearning #Python #FastAPI #NVIDIA
```

---

## 📈 Analytics Setup (Optional)

### Add Google Analytics

Edit `static/index.html`:

```html
<head>
    <!-- ... existing head content ... -->
    
    <!-- Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=YOUR-GA-ID"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'YOUR-GA-ID');
    </script>
</head>
```

---

## 🔒 Security Best Practices

### 1. Regular Updates

```bash
# Create update script
sudo nano /opt/nvidia-nim-swtich-python/update.sh
```

```bash
#!/bin/bash
cd /opt/nvidia-nim-swtich-python
git pull
uv sync
sudo systemctl restart nvidia-nim-switch
```

### 2. Backup Configuration

```bash
# Backup .env file
sudo cp /opt/nvidia-nim-swtich-python/.env /opt/nvidia-nim-swtich-python/.env.backup

# Backup Nginx config
sudo cp /etc/nginx/sites-available/models.bluehawana.com /etc/nginx/sites-available/models.bluehawana.com.backup
```

### 3. Monitor Failed Requests

```bash
# Check for 429 (rate limit) errors
grep "429" /var/log/nginx/models.bluehawana.com-access.log | tail -20

# Check for 500 errors
grep "500" /var/log/nginx/models.bluehawana.com-access.log | tail -20
```

---

## 🎉 Deployment Complete!

Your service is now live at: **https://models.bluehawana.com**

### Quick Links:
- 🌐 Web Interface: https://models.bluehawana.com/
- 📚 API Docs: https://models.bluehawana.com/docs
- 💚 Health Check: https://models.bluehawana.com/health
- 📊 Current Model: https://models.bluehawana.com/v1/models/current

### Next Steps:
1. ✅ Test all features
2. ✅ Monitor usage and performance
3. ✅ Promote on social media
4. ✅ Gather user feedback
5. ✅ Iterate and improve

---

**Your free trial service is ready to help developers worldwide!** 🚀
