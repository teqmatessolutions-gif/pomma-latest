# 🚀 Deploy to Google Cloud VM — pommaholidays.com

## What This Script Does
- Installs all server dependencies (Python, Node, Nginx, Certbot)
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

# ── 2. Install Python 3.11, pip, venv ────────────────────────────────────────
sudo apt install -y python3.11 python3.11-venv python3-pip git

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
git clone https://github.com/YOUR_REPO/pomma-latest.git .
```

---

## Part 3 — Backend Setup

```bash
cd /opt/pomma

# Create Python virtual environment
python3.11 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r ResortApp/requirements.txt

# Create .env file (edit with your actual DB credentials)
cat > /opt/pomma/ResortApp/.env << 'EOF'
DATABASE_URL=postgresql://YOUR_DB_USER:YOUR_DB_PASS@localhost:5432/pomma_db
SECRET_KEY=your-secret-key-here-change-this
ROOT_PATH=
EOF

# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Create database
sudo -u postgres psql -c "CREATE USER pomma_user WITH PASSWORD 'your_password';"
sudo -u postgres psql -c "CREATE DATABASE pomma_db OWNER pomma_user;"

# Run database migrations
cd /opt/pomma/ResortApp
source /opt/pomma/venv/bin/activate
alembic upgrade head
```

---

## Part 4 — Create Systemd Service for FastAPI

```bash
sudo tee /etc/systemd/system/pomma.service << 'EOF'
[Unit]
Description=Pomma Holidays FastAPI Backend
After=network.target postgresql.service

[Service]
User=www-data
Group=www-data
WorkingDirectory=/opt/pomma/ResortApp
ExecStart=/opt/pomma/venv/bin/uvicorn app.main:app --host 127.0.0.1 --port 8000 --workers 2
Restart=always
RestartSec=5
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=pomma-backend

[Install]
WantedBy=multi-user.target
EOF

# Fix permissions
sudo chown -R www-data:www-data /opt/pomma/ResortApp

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable pomma
sudo systemctl start pomma

# Verify it's running
sudo systemctl status pomma
curl http://127.0.0.1:8000/api/health
```

---

## Part 5 — Build React Apps

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
    ssl_protocols TLSv1.2 TLSv1.3;

    # API — FastAPI backend
    location /api/ {
        proxy_pass http://127.0.0.1:8000/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        client_max_body_size 50M;
        proxy_read_timeout 300;
    }

    # Uploads from backend
    location /uploads/ {
        alias /opt/pomma/ResortApp/uploads/;
        expires 30d;
        add_header Cache-Control "public";
        try_files $uri =404;
    }

    # Static files from backend
    location /static/ {
        alias /opt/pomma/ResortApp/static/;
        expires 30d;
        add_header Cache-Control "public";
        try_files $uri =404;
    }

    # Admin Dashboard (React — /admin)
    location /admin {
        alias /opt/pomma/dasboard-build/;
        index index.html;
        try_files $uri $uri/ /admin/index.html;
    }

    # User-facing app (React — root /)
    location / {
        root /opt/pomma/userend-build/;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
}
NGINX

# Enable site
sudo ln -s /etc/nginx/sites-available/pommaholidays /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test config
sudo nginx -t
```

---

## Part 7 — Get SSL Certificate (Free via Let's Encrypt)

> ⚠️ Your domain's DNS A record must point to the VM's IP BEFORE doing this.

```bash
# Point your domain first:
# pommaholidays.com  →  A  →  YOUR_VM_IP
# www.pommaholidays.com  →  A  →  YOUR_VM_IP

# Then get SSL certificate
sudo certbot --nginx -d pommaholidays.com -d www.pommaholidays.com

# Reload Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
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
