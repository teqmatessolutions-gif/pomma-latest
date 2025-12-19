#!/bin/bash

# Pomma Holidays - Deployment Script for Ubuntu 22.04 LTS
# Usage: sudo ./deploy_to_server.sh

set -e

echo ">>> Updating System..."
apt update && apt upgrade -y

echo ">>> Installing Dependencies..."
apt install -y python3.11 python3.11-venv python3-pip nodejs npm postgresql postgresql-contrib nginx git acl

# Verify Node version (install n if needed for newer node)
npm install -g n
n stable

echo ">>> Setting up Database..."
# Create DB user and DB if not exists (using postgres user)
# NOTE: You will need to set the password manually or update env
sudo -u postgres psql -c "CREATE DATABASE pommadb;" || true
sudo -u postgres psql -c "CREATE USER pommauser WITH PASSWORD 'pommapass';" || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE pommadb TO pommauser;" || true

echo ">>> Cloning Repository..."
# Using HTTP clone for public/token auth or assume keys are set up
TARGET_DIR="/opt/pomma"
if [ -d "$TARGET_DIR" ]; then
    echo "Directory exists, pulling latest..."
    cd $TARGET_DIR
    git pull
else
    git clone https://github.com/teqmatessolutions-gif/pomma-latest.git $TARGET_DIR
    cd $TARGET_DIR
    git checkout final
fi

# Fix permissions
chown -R $USER:www-data $TARGET_DIR
chmod -R 775 $TARGET_DIR

echo ">>> Setting up Backend..."
cd $TARGET_DIR/ResortApp
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements_production.txt
# Create .env if not exists (User must edit this!)
if [ ! -f .env ]; then
    cp .env.example .env || echo "DATABASE_URL=postgresql://pommauser:pommapass@localhost/pommadb" > .env
fi

# Migrations
# alembic upgrade head # Uncomment if alembic is configured

echo ">>> Building User Frontend..."
cd $TARGET_DIR/userend/userend
npm install
npm run build
# Move to web root
mkdir -p /var/www/pomma
cp -r build/* /var/www/pomma/

echo ">>> Building Dashboard..."
cd $TARGET_DIR/dasboard
npm install
npm run build
# Move to web root
mkdir -p /var/www/pommaadmin
cp -r build/* /var/www/pommaadmin/

echo ">>> Setting up Landing Page..."
mkdir -p /var/www/html
cp -r $TARGET_DIR/landingpage/* /var/www/html/

echo ">>> Deployment Complete!"
echo "Next Steps:"
echo "1. Edit /opt/pomma/ResortApp/.env with correct DB/SMTP credentials."
echo "2. Copy nginx_resort.conf to /etc/nginx/sites-available/pomma"
echo "3. Copy resort.service to /etc/systemd/system/"
echo "4. Start services!"
