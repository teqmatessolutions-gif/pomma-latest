# Resort Management System - Quick Start Guide

## 🚀 Quick Setup Summary

### Server Deployment

1. **Clone and Deploy:**
   ```bash
   # On server
   cd /var/www/resort
   bash deploy_resort_to_server.sh
   ```

2. **Add Nginx Configuration:**
   - Add location blocks from `nginx_resort_paths.conf` to main nginx config
   - Test: `nginx -t`
   - Reload: `systemctl reload nginx`

3. **Start Service:**
   ```bash
   systemctl start resort.service
   systemctl status resort.service
   ```

### Local Development

1. **Setup Database:**
   ```powershell
   cd C:\releasing\Pumaholidays
   .\setup_resort_database_local.ps1
   ```

2. **Clone Repository:**
   ```powershell
   cd C:\releasing
   git clone https://github.com/teqmatessolutions-gif/Resort.git
   ```

3. **Setup Backend:**
   ```powershell
   cd C:\releasing\Resort\ResortApp
   python -m venv venv
   .\venv\Scripts\activate
   pip install -r requirements.txt
   # Create .env file (see RESORT_LOCAL_SETUP.md)
   python main.py
   ```

4. **Setup Frontend:**
   ```powershell
   # Admin Dashboard
   cd C:\releasing\Resort\dasboard
   npm install --legacy-peer-deps
   npm start

   # User Frontend (new terminal)
   cd C:\releasing\Resort\userend\userend
   npm install --legacy-peer-deps
   npm start
   ```

---

## 📍 URLs

### Server (Production)
- **User Frontend:** https://teqmates.com/resort/
- **Admin Dashboard:** https://teqmates.com/resortadmin/
- **API Base:** https://teqmates.com/resortapi/api/
- **File Uploads:** https://teqmates.com/resortfiles/

### Local Development
- **Backend API:** http://localhost:8012
- **API Docs:** http://localhost:8012/docs
- **Admin Dashboard:** http://localhost:3000
- **User Frontend:** http://localhost:3001

---

## 🗄️ Database

- **Name:** `resort`
- **User:** `resortuser`
- **Password:** `resort123` (change in production!)
- **Connection:** `postgresql+psycopg2://resortuser:resort123@localhost:5432/resort`

---

## 🔧 Service Management

### Server Commands

```bash
# Service status
systemctl status resort.service

# View logs
journalctl -u resort.service -f

# Restart service
systemctl restart resort.service

# Stop service
systemctl stop resort.service
```

### Database Access

```bash
# Connect to database
sudo -u postgres psql resort -U resortuser

# List tables
\dt

# Exit
\q
```

---

## 📝 Key Files

| File | Purpose |
|------|---------|
| `RESORT_DEPLOYMENT_COMPLETE.md` | Complete server deployment reference |
| `RESORT_LOCAL_SETUP.md` | Local development setup guide |
| `setup_resort_database.sh` | Server database setup script |
| `setup_resort_database_local.ps1` | Local database setup script (Windows) |
| `deploy_resort_to_server.sh` | Complete server deployment script |
| `nginx_resort_paths.conf` | Nginx location blocks for resort paths |
| `resort.service` | Systemd service file |

---

## ⚙️ Configuration

### Backend Port
- **Default:** 8012
- **Config:** `.env` file `PORT=8012`

### API Path
- **Server:** `/resortapi/`
- **Local:** Direct access on port 8012

### Frontend Paths
- **User:** `/resort/`
- **Admin:** `/resortadmin/`

---

## 🔍 Verification

### Check Service
```bash
# Server
systemctl status resort.service
curl http://127.0.0.1:8012/health

# Local
curl http://localhost:8012/health
```

### Check Database
```bash
# Server
sudo -u postgres psql resort -U resortuser -c "SELECT COUNT(*) FROM rooms;"

# Local
psql -U resortuser -d resort -c "SELECT COUNT(*) FROM rooms;"
```

### Check Nginx
```bash
# Test configuration
nginx -t

# Check for resort paths
grep -r "resort" /etc/nginx/sites-enabled/
```

---

## 🐛 Common Issues

### Port Already in Use
```bash
# Find process
netstat -tlnp | grep 8012
# or on Windows
netstat -ano | findstr :8012

# Kill process (replace PID)
kill -9 <PID>
```

### Database Connection Failed
- Check PostgreSQL is running
- Verify credentials in `.env`
- Check `pg_hba.conf` for authentication

### Nginx 502 Bad Gateway
- Check backend is running: `systemctl status resort.service`
- Check port: `netstat -tlnp | grep 8012`
- Check logs: `journalctl -u resort.service -n 50`

---

## 📚 Documentation

- **Full Deployment Guide:** `RESORT_DEPLOYMENT_COMPLETE.md`
- **Local Setup:** `RESORT_LOCAL_SETUP.md`
- **Orchid Reference:** `ORCHID_DEPLOYMENT_COMPLETE.md` (similar setup)

---

## 🆘 Support

For detailed information, refer to:
- `RESORT_DEPLOYMENT_COMPLETE.md` - Complete server setup
- `RESORT_LOCAL_SETUP.md` - Local development guide
- Server logs: `journalctl -u resort.service -f`
- Nginx logs: `/var/log/nginx/error.log`

