#!/bin/bash
# eFIND Production Proxy Setup Script
# This script configures Apache on the host to proxy requests to the Docker container

set -e  # Exit on error

echo "================================="
echo "eFIND Production Proxy Setup"
echo "================================="
echo ""

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "This script must be run with sudo"
    echo "Usage: sudo bash setup-production-proxy.sh"
    exit 1
fi

echo "Step 1: Enabling Apache proxy modules..."
a2enmod proxy proxy_http
echo "✓ Proxy modules enabled"
echo ""

echo "Step 2: Backing up current Apache configuration..."
if [ -f /etc/apache2/sites-available/000-default.conf ]; then
    cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.backup-$(date +%Y%m%d-%H%M%S)
    echo "✓ Backup created"
else
    echo "⚠ No existing config found, creating new one"
fi
echo ""

echo "Step 3: Creating new Apache proxy configuration..."
cat > /etc/apache2/sites-available/000-default.conf << 'EOF'
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    # Proxy all requests to eFIND Docker container
    ProxyPreserveHost On
    ProxyPass / http://localhost:7070/
    ProxyPassReverse / http://localhost:7070/

    # Logging
    ErrorLog ${APACHE_LOG_DIR}/efind_error.log
    CustomLog ${APACHE_LOG_DIR}/efind_access.log combined

    # Optional: Add timeout settings
    ProxyTimeout 300
</VirtualHost>
EOF
echo "✓ Configuration file updated"
echo ""

echo "Step 4: Testing Apache configuration..."
apache2ctl configtest
echo ""

echo "Step 5: Restarting Apache..."
systemctl restart apache2
echo "✓ Apache restarted successfully"
echo ""

echo "Step 6: Verifying Docker container is running..."
if docker ps | grep -q efind-app; then
    echo "✓ eFIND Docker container is running"
else
    echo "⚠ WARNING: eFIND Docker container is not running!"
    echo "  Please start it with: cd /home/delfin/code && docker compose up -d"
    exit 1
fi
echo ""

echo "Step 7: Testing the setup..."
sleep 2
echo "Testing localhost..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost/admin/login.php | grep -q "200"; then
    echo "✓ Login page is accessible via localhost"
else
    echo "⚠ WARNING: Login page test failed"
fi
echo ""

echo "Testing public IP..."
PUBLIC_IP=$(curl -s ifconfig.me || echo "unknown")
if [ "$PUBLIC_IP" != "unknown" ]; then
    echo "Your public IP: $PUBLIC_IP"
    echo "Production URL: http://$PUBLIC_IP/admin/login.php"
else
    echo "Could not detect public IP"
fi
echo ""

echo "================================="
echo "✓ Setup Complete!"
echo "================================="
echo ""
echo "Your eFIND application should now be accessible at:"
echo "  - http://localhost/admin/login.php (from server)"
echo "  - http://$PUBLIC_IP/admin/login.php (from internet)"
echo ""
echo "Logs are available at:"
echo "  - /var/log/apache2/efind_error.log"
echo "  - /var/log/apache2/efind_access.log"
echo ""
echo "If you have a domain name, you can add it to the Apache config:"
echo "  ServerName yourdomain.com"
echo "  ServerAlias www.yourdomain.com"
echo ""
