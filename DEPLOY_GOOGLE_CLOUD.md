# 🚀 Deploy to Google Cloud VM — IP or Domain (PROTECTED VERSION)

## What This Script Does
- Installs all server dependencies (Python, Node, Nginx, Certbot)
- **Obfuscates backend code** with PyArmor for source protection
- **Disables source maps** for React builds to prevent reverse-engineering
- Sets up the FastAPI backend as a `systemd` service
- Builds and deploys both React apps
- Configures Nginx with SSL for pommaholidays.com
- Makes userend available at `/` and dashboard at `/admin`

---

## Part 1 — First Time Server Setup (Run ONCE after VM creation)

SSH into your server and run these commands:

```bash
# ── 1. Update system ─────────────────────────────────────────────────────────
sudo apt update && sudo apt upgrade -y

# ── 2. Install Python, pip, venv ───────────────────────────────────────────
# Most modern Ubuntu versions have Python 3.10+ by default.
sudo apt install -y python3 python3-venv python3-pip git

# Check your version
python3 --version

# NOTE: If you strictly need Python 3.11 and it was not found, run:
# sudo add-apt-repository ppa:deadsnakes/ppa -y
# sudo apt update
# sudo apt install -y python3.11 python3.11-venv

# ── 3. Install Node.js 20 (LTS) ──────────────────────────────────────────────
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# ── 4. Install Nginx + Certbot ───────────────────────────────────────────────
sudo apt install -y nginx certbot python3-certbot-nginx

# ── 5. Create app directory ───────────────────────────────────────────────────
sudo mkdir -p /opt/pomma
sudo chown $USER:$USER /opt/pomma
```

---

## Part 2 — Upload Your Code

From your **Windows machine**, run:

```powershell
# Replace YOUR_VM_IP with the actual IP from Google Cloud Console
scp -r d:\resort_oc_10\Resortwithlandingpage\pomma-latest username@YOUR_VM_IP:/opt/pomma/
```

Or use **GitHub** (recommended):
```bash
# On the VM
cd /opt/pomma
# Clone the 'final' branch specifically
git clone -b final https://github.com/teqmatessolutions-gif/pomma-latest.git .
```

---

## Part 3 — Backend Setup & Obfuscation

```bash
cd /opt/pomma

# Create Python virtual environment
python3.11 -m venv venv
source venv/bin/activate

# Install dependencies including Cython
pip install -r ResortApp/requirements.txt
sudo apt install -y build-essential python3-dev

# �️ RUN BINARY COMPILATION (Cython)
cd ResortApp
python3 compile_backend.py
# This converts .py files into unreadable binary modules (.so) in the 'dist/' folder
```

---

## Part 4 — Create Systemd Service (Targeting Binary Code)

```bash
sudo tee /etc/systemd/system/pomma.service << 'EOF'
[Unit]
Description=Pomma Holidays FastAPI Backend (Binary/Protected)
After=network.target postgresql.service

[Service]
User=www-data
Group=www-data
# 🛡️ POINTING TO THE DIST FOLDER WITH BINARIES
WorkingDirectory=/opt/pomma/ResortApp/dist
ExecStart=/opt/pomma/venv/bin/python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --workers 2
Restart=always
RestartSec=5
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=pomma-backend

[Install]
WantedBy=multi-user.target
EOF

# Fix permissions
sudo chown -R www-data:www-data /opt/pomma/ResortApp/dist

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable pomma
sudo systemctl start pomma
```

---

## Part 5 — Build React Apps (Source Maps Disabled)

Both apps now have `GENERATE_SOURCEMAP=false` in `.env.production`.

```bash
# ── Build Dashboard (/admin) ──────────────────────────────────────────────────
cd /opt/pomma/dasboard
npm install --legacy-peer-deps
npm run build:prod

# Deploy dashboard build
sudo mkdir -p /opt/pomma/dasboard-build
sudo cp -r build/* /opt/pomma/dasboard-build/

# ── Build Userend (/) ─────────────────────────────────────────────────────────
cd /opt/pomma/userend/userend
npm install --legacy-peer-deps
npm run build:prod

# Deploy userend build
sudo mkdir -p /opt/pomma/userend-build
sudo cp -r build/* /opt/pomma/userend-build/
```

---

## Part 6 — Configure Nginx

```bash
# Test config
sudo nginx -t
```

---

## Part 7 — Configure Nginx (Choose OPTION A or B)

### OPTION A: Testing via Server IP (No Domain Yet)
Use this if you just want to test using the numeric IP from Google Cloud.

```bash
sudo tee /etc/nginx/sites-available/pommaholidays << 'NGINX'
server {
    listen 80;
    server_name _; # Listen to all requests (IP address)

    # API — FastAPI backend
    location /api/ {
        proxy_pass http://127.0.0.1:8000/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        client_max_body_size 50M;
    }

    # Uploads & Static
    location /uploads/ { alias /opt/pomma/ResortApp/uploads/; }
    location /static/ { alias /opt/pomma/ResortApp/static/; }

    # Dashboard (/admin)
    location /admin {
        alias /opt/pomma/dasboard-build/;
        index index.html;
        try_files $uri $uri/ /admin/index.html;
    }

    # User-facing app (/)
    location / {
        root /opt/pomma/userend-build/;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
}
NGINX

# Restart Nginx
sudo nginx -t
sudo systemctl restart nginx
```

### OPTION B: Production with Domain & SSL
Use this once your domain is pointing to the IP.

```bash
# 1. Get SSL certificate
sudo certbot --nginx -d pommaholidays.com -d www.pommaholidays.com

# 2. Apply FULL SSL config
sudo tee /etc/nginx/sites-available/pommaholidays << 'NGINX'
server {
    listen 80;
    server_name pommaholidays.com www.pommaholidays.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name pommaholidays.com www.pommaholidays.com;

    ssl_certificate /etc/letsencrypt/live/pommaholidays.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/pommaholidays.com/privkey.pem;

    location /api/ { proxy_pass http://127.0.0.1:8000/api/; proxy_set_header Host $host; }
    location /uploads/ { alias /opt/pomma/ResortApp/uploads/; }
    location /static/ { alias /opt/pomma/ResortApp/static/; }
    location /admin {
        alias /opt/pomma/dasboard-build/;
        index index.html;
        try_files $uri $uri/ /admin/index.html;
    }
    location / {
        root /opt/pomma/userend-build/;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
}
NGINX

sudo nginx -t
sudo systemctl restart nginx
```

---

## Part 8 — Verify Everything

```bash
# Backend health
curl https://pommaholidays.com/api/health

# Check services
sudo systemctl status pomma
sudo systemctl status nginx

# View backend logs live
sudo journalctl -u pomma -f
```

---

## Updating the App in Future (After Code Changes)

```bash
cd /opt/pomma
git pull origin main

# Rebuild dashboard if changed
cd dasboard && npm run build:prod && sudo cp -r build/* /opt/pomma/dasboard-build/

# Rebuild userend if changed
cd ../userend/userend && npm run build:prod && sudo cp -r build/* /opt/pomma/userend-build/

# Restart backend if Python code changed
sudo systemctl restart pomma

# Reload nginx if config changed
sudo systemctl reload nginx
```

---

## DNS Configuration (Namecheap / GoDaddy / Cloudflare)

| Type | Host | Value |
|------|------|-------|
| A | @ | YOUR_VM_IP |
| A | www | YOUR_VM_IP |

Wait 5–30 minutes for DNS to propagate after updating.

---

## ✅ Expected Result

| URL | What you see |
|-----|-------------|
| `https://pommaholidays.com/` | Guest-facing resort booking app |
| `https://pommaholidays.com/admin` | Staff dashboard login |
| `https://pommaholidays.com/api/health` | `{"status": "ok"}` JSON |
