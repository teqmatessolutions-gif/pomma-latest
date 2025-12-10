# Server Connection Details - Complete Reference

## 🔌 Server Information

### Basic Connection Details
- **IP Address:** `139.84.211.200`
- **Domain:** `www.teqmates.com` / `teqmates.com`
- **Username:** `root`
- **SSH Port:** `22`
- **Hosting Provider:** Vultr (based on hostname `vultrusercontent.com`)

### SSH Connection Command
```bash
ssh root@139.84.211.200
```

---

## 📁 Server Paths

### Main Project Paths
- **Main Project Root:** `/var/www/resort/Resort_first`
- **Pomma Production:** `/var/www/resort/pomma_production/ResortApp`
- **Orchid Production:** `/var/www/resort/orchid_production`
- **Resort Production:** `/var/www/resort/resort_production` (new)

### Frontend Build Paths
- **User Frontend (Pomma):** `/var/www/resort/Resort_first/userend/userend/build`
- **Admin Dashboard (Pomma):** `/var/www/resort/Resort_first/dasboard/build`
- **User Frontend (Orchid):** `/var/www/resort/orchid_production/userend/userend/build`
- **Admin Dashboard (Orchid):** `/var/www/resort/orchid_production/dasboard/build`
- **Landing Page:** `/var/www/resort/Resort_first/landingpage`

### Backend Paths
- **Pomma Backend:** `/var/www/resort/pomma_production/ResortApp`
- **Orchid Backend:** `/var/www/resort/orchid_production/ResortApp`
- **Resort Backend:** `/var/www/resort/resort_production/ResortApp` (new)

### Uploads & Static Files
- **Pomma Uploads:** `/var/www/resort/pomma_production/ResortApp/uploads/`
- **Orchid Uploads:** `/var/www/resort/orchid_production/ResortApp/uploads/`
- **Resort Uploads:** `/var/www/resort/resort_production/ResortApp/uploads/` (new)

---

## 🌐 Domain & URL Structure

### Main Domain
- **Domain:** `teqmates.com` / `www.teqmates.com`
- **SSL Certificate:** `/etc/letsencrypt/live/teqmates.com/`

### PommaHolidays Paths (Path-based, not subdomain)
- **User Frontend:** `https://teqmates.com/pommaholidays/`
- **Admin Dashboard:** `https://teqmates.com/pommaadmin/`
- **API Endpoint:** `https://teqmates.com/pommaapi/api/`
- **File Uploads:** `https://teqmates.com/pomma/uploads/`

### Orchid Paths (Path-based, not subdomain)
- **User Frontend:** `https://teqmates.com/orchid/`
- **Admin Dashboard:** `https://teqmates.com/orchidadmin/`
- **API Endpoint:** `https://teqmates.com/orchidapi/api/`
- **File Uploads:** `https://teqmates.com/orchidfiles/`

### Resort Paths (New - Path-based)
- **User Frontend:** `https://teqmates.com/resort/`
- **Admin Dashboard:** `https://teqmates.com/resortadmin/`
- **API Endpoint:** `https://teqmates.com/resortapi/api/`
- **File Uploads:** `https://teqmates.com/resortfiles/`

---

## 🔧 Service Configuration

### Backend Services

#### Pomma Service
- **Service Name:** `resort.service` or `pommoapi.service`
- **Port:** `8010`
- **Upstream:** `pomma_backend`
- **Status Check:** `systemctl status resort.service`

#### Orchid Service
- **Service Name:** `orchid.service`
- **Port:** `8011`
- **Upstream:** `orchid_backend`
- **Status Check:** `systemctl status orchid.service`

#### Resort Service (New)
- **Service Name:** `resort.service`
- **Port:** `8012`
- **Upstream:** `resort_backend`
- **Status Check:** `systemctl status resort.service`

### Nginx Configuration
- **Config Location:** `/etc/nginx/sites-available/` or `/etc/nginx/conf.d/`
- **Main Config:** `/etc/nginx/sites-available/teqmates` or `nginx_resort.conf`
- **Test Config:** `nginx -t`
- **Reload:** `systemctl reload nginx`

### Log Files
- **Nginx Access:** `/var/log/nginx/access.log`
- **Nginx Error:** `/var/log/nginx/error.log`
- **Pomma Service:** `journalctl -u resort.service -f`
- **Orchid Service:** `journalctl -u orchid.service -f`
- **Resort Service:** `journalctl -u resort.service -f`

---

## 🗄️ Database Configuration

### Pomma Database
- **Database Name:** `pommodb`
- **Database User:** `pommauser` (or check actual user)
- **Connection:** `postgresql+psycopg2://pommauser:password@localhost:5432/pommodb`

### Orchid Database
- **Database Name:** `orchiddb`
- **Database User:** `orchiduser`
- **Password:** `orchid123`
- **Connection:** `postgresql+psycopg2://orchiduser:orchid123@localhost:5432/orchiddb`

### Resort Database (New)
- **Database Name:** `resort`
- **Database User:** `resortuser`
- **Password:** `resort123` (change in production!)
- **Connection:** `postgresql+psycopg2://resortuser:resort123@localhost:5432/resort`

### PostgreSQL Access
```bash
# Connect to database
sudo -u postgres psql <database_name> -U <username>

# List all databases
sudo -u postgres psql -l

# List tables
\dt

# Exit
\q
```

---

## 🔐 Connection Methods

### Method 1: SSH via PowerShell/Command Line
```powershell
ssh root@139.84.211.200
```
Enter root password when prompted.

### Method 2: PuTTY (Windows GUI)
1. Download PuTTY: https://www.putty.org/
2. Open PuTTY
3. Enter:
   - **Host Name:** `139.84.211.200`
   - **Port:** `22`
   - **Connection Type:** SSH
4. Click "Open"
5. Enter username: `root`
6. Enter password when prompted

### Method 3: WinSCP (File Transfers)
1. Download WinSCP: https://winscp.net/
2. Connect with:
   - **Host:** `139.84.211.200`
   - **Username:** `root`
   - **Protocol:** SFTP
3. Browse and transfer files

### Method 4: Vultr Console (Browser-based)
1. Go to: https://my.vultr.com/
2. Log in to your account
3. Find server: `139.84.211.200`
4. Click: "View Console" or "Launch Console"
5. Browser terminal opens (no password needed!)

### Method 5: Hosting Control Panel
If you have cPanel/Plesk/DirectAdmin:
1. Log in to hosting control panel
2. Look for "Terminal" or "SSH Access"
3. Click to open browser-based terminal

---

## 📋 Quick Commands

### Navigation
```bash
# Navigate to main project
cd /var/www/resort/Resort_first

# Navigate to Pomma production
cd /var/www/resort/pomma_production

# Navigate to Orchid production
cd /var/www/resort/orchid_production

# Navigate to Resort production (new)
cd /var/www/resort/resort_production
```

### Git Operations
```bash
# Check git status
git status

# Pull latest changes
git pull origin main

# Check current branch
git branch

# View recent commits
git log -5 --oneline
```

### Service Management
```bash
# Check service status
systemctl status resort.service
systemctl status orchid.service
systemctl status nginx

# Start service
systemctl start resort.service

# Stop service
systemctl stop resort.service

# Restart service
systemctl restart resort.service

# Reload service (after config changes)
systemctl reload resort.service

# View logs
journalctl -u resort.service -f
journalctl -u orchid.service -f
```

### Nginx Operations
```bash
# Test configuration
nginx -t

# Reload nginx
systemctl reload nginx

# Restart nginx
systemctl restart nginx

# Check nginx status
systemctl status nginx

# View error logs
tail -f /var/log/nginx/error.log

# View access logs
tail -f /var/log/nginx/access.log
```

### Port Checking
```bash
# Check if port is listening
netstat -tlnp | grep 8010  # Pomma
netstat -tlnp | grep 8011  # Orchid
netstat -tlnp | grep 8012  # Resort

# Or using ss
ss -tlnp | grep 8010
```

### Database Operations
```bash
# Connect to database
sudo -u postgres psql <database_name> -U <username>

# List all databases
sudo -u postgres psql -l

# List tables in database
sudo -u postgres psql <database_name> -U <username> -c "\dt"

# Query rooms
sudo -u postgres psql <database_name> -U <username> -c "SELECT COUNT(*) FROM rooms;"
```

### File Permissions
```bash
# Set ownership
chown -R www-data:www-data /var/www/resort/resort_production

# Set permissions
chmod -R 755 /var/www/resort/resort_production
chmod -R 777 /var/www/resort/resort_production/ResortApp/uploads
```

---

## 🔍 Verification Commands

### Check Service Status
```bash
# Pomma
systemctl status resort.service
curl http://127.0.0.1:8010/health

# Orchid
systemctl status orchid.service
curl http://127.0.0.1:8011/health

# Resort
systemctl status resort.service
curl http://127.0.0.1:8012/health
```

### Check Frontend Builds
```bash
# Pomma
ls -la /var/www/resort/Resort_first/userend/userend/build/
ls -la /var/www/resort/Resort_first/dasboard/build/

# Orchid
ls -la /var/www/resort/orchid_production/userend/userend/build/
ls -la /var/www/resort/orchid_production/dasboard/build/

# Resort
ls -la /var/www/resort/resort_production/userend/userend/build/
ls -la /var/www/resort/resort_production/dasboard/build/
```

### Check Nginx Configuration
```bash
# Test configuration
nginx -t

# Check for specific paths
grep -r "pommaholidays" /etc/nginx/sites-enabled/
grep -r "orchid" /etc/nginx/sites-enabled/
grep -r "resort" /etc/nginx/sites-enabled/
```

### Test Public URLs
```bash
# Pomma
curl -I https://teqmates.com/pommaholidays/
curl -I https://teqmates.com/pommaadmin/
curl https://teqmates.com/pommaapi/api/health

# Orchid
curl -I https://teqmates.com/orchid/
curl -I https://teqmates.com/orchidadmin/
curl https://teqmates.com/orchidapi/api/health

# Resort
curl -I https://teqmates.com/resort/
curl -I https://teqmates.com/resortadmin/
curl https://teqmates.com/resortapi/api/health
```

---

## 📚 Repository Information

### Pomma Repository
- **URL:** `https://github.com/teqmatessolutions-gif/pomma-latest.git`
- **Path:** `/var/www/resort/Resort_first`

### Orchid Repository
- **URL:** `https://github.com/teqmatessolutions-gif/orchidresort.git`
- **Branch:** `master`
- **Path:** `/var/www/resort/orchid_production`

### Resort Repository (New)
- **URL:** `https://github.com/teqmatessolutions-gif/Resort.git`
- **Branch:** `main` (or `master` - verify)
- **Path:** `/var/www/resort/resort_production`

---

## 🛠️ Common Tasks

### Deploy Code Updates
```bash
# Navigate to project
cd /var/www/resort/<project_path>

# Pull latest changes
git pull origin main

# Rebuild frontend (if needed)
cd dasboard
npm install --legacy-peer-deps
npm run build

cd ../userend/userend
npm install --legacy-peer-deps
npm run build

# Restart services
cd ../ResortApp
systemctl restart <service_name>
systemctl reload nginx
```

### Check Logs
```bash
# Service logs
journalctl -u resort.service -n 50
journalctl -u orchid.service -n 50

# Nginx logs
tail -f /var/log/nginx/error.log
tail -f /var/log/nginx/access.log | grep <path>
```

### Database Backup
```bash
# Backup database
sudo -u postgres pg_dump <database_name> > /var/backups/<database_name>_$(date +%Y%m%d).sql

# Restore database
sudo -u postgres psql <database_name> < /var/backups/<database_name>_backup.sql
```

---

## ⚠️ Important Notes

1. **SSH Access:** Requires root password. If password authentication fails, use Vultr console or hosting control panel.

2. **Service Names:** Multiple services may use similar names. Check which service corresponds to which project:
   - `resort.service` might be Pomma or Resort
   - `orchid.service` is specifically for Orchid

3. **Ports:** Each project uses a different port:
   - Pomma: `8010`
   - Orchid: `8011`
   - Resort: `8012`

4. **Database Passwords:** Change default passwords in production!

5. **SSL Certificates:** All use Let's Encrypt certificates at `/etc/letsencrypt/live/teqmates.com/`

---

## 📞 Support & Troubleshooting

### Connection Issues
- Use Vultr console if SSH fails
- Check firewall settings
- Verify IP address is correct

### Service Issues
- Check logs: `journalctl -u <service_name> -f`
- Verify port is listening: `netstat -tlnp | grep <port>`
- Check database connection

### Nginx Issues
- Test configuration: `nginx -t`
- Check error logs: `tail -f /var/log/nginx/error.log`
- Verify location blocks are correct

---

## 📝 Summary

**Server:** `root@139.84.211.200`  
**Main Domain:** `teqmates.com`  
**Projects:** Pomma (8010), Orchid (8011), Resort (8012)  
**Base Path:** `/var/www/resort/`

All projects use path-based routing on the main domain, not separate subdomains.

