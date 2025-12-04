#!/bin/bash
# eFIND 404 Diagnostic Script

echo "================================================"
echo "eFIND 404 Diagnostic Report"
echo "================================================"
echo ""

echo "1. Testing Docker Container (port 7070)"
echo "----------------------------------------"
echo -n "Direct access to login.php: "
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:7070/admin/login.php)
if [ "$STATUS" = "200" ]; then
    echo "✓ SUCCESS (HTTP $STATUS)"
else
    echo "✗ FAILED (HTTP $STATUS)"
fi
echo ""

echo "2. Testing Host Apache (port 80)"
echo "----------------------------------------"
echo -n "Host Apache root: "
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)
echo "HTTP $STATUS"

echo -n "Host Apache /admin/login.php: "
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/admin/login.php)
if [ "$STATUS" = "200" ]; then
    echo "✓ SUCCESS (HTTP $STATUS)"
else
    echo "✗ FAILED (HTTP $STATUS)"
fi
echo ""

echo "3. Apache Configuration Check"
echo "----------------------------------------"
if grep -q "ProxyPass" /etc/apache2/sites-available/000-default.conf 2>/dev/null; then
    echo "✓ Proxy configuration found"
else
    echo "✗ NO PROXY CONFIGURATION"
    echo "  The setup script has NOT been run yet!"
fi
echo ""

echo "4. Enabled Apache Modules"
echo "----------------------------------------"
if [ -f /etc/apache2/mods-enabled/proxy.load ]; then
    echo "✓ proxy module enabled"
else
    echo "✗ proxy module NOT enabled"
fi

if [ -f /etc/apache2/mods-enabled/proxy_http.load ]; then
    echo "✓ proxy_http module enabled"
else
    echo "✗ proxy_http module NOT enabled"
fi
echo ""

echo "5. Docker Container Status"
echo "----------------------------------------"
if docker ps | grep -q efind-app; then
    echo "✓ efind-app container is running"
    docker ps --filter "name=efind-app" --format "  Port: {{.Ports}}"
else
    echo "✗ efind-app container is NOT running"
fi
echo ""

echo "6. Network Connectivity"
echo "----------------------------------------"
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "unknown")
echo "Public IP: $PUBLIC_IP"
echo ""

echo "7. Testing Public URLs"
echo "----------------------------------------"
if [ "$PUBLIC_IP" != "unknown" ]; then
    echo "Testing http://$PUBLIC_IP/admin/login.php"
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://$PUBLIC_IP/admin/login.php 2>/dev/null || echo "timeout")
    if [ "$STATUS" = "200" ]; then
        echo "✓ Public URL works! (HTTP $STATUS)"
    else
        echo "✗ Public URL failed (HTTP $STATUS)"
    fi
fi
echo ""

echo "8. Recent Apache Access (last 5 requests)"
echo "----------------------------------------"
docker exec efind-app tail -5 /var/log/apache2/access.log 2>/dev/null || echo "Cannot read Docker logs"
echo ""

echo "================================================"
echo "DIAGNOSIS SUMMARY"
echo "================================================"

# Determine the issue
DOCKER_OK=false
PROXY_OK=false

if [ "$(curl -s -o /dev/null -w "%{http_code}" http://localhost:7070/admin/login.php)" = "200" ]; then
    DOCKER_OK=true
fi

if grep -q "ProxyPass" /etc/apache2/sites-available/000-default.conf 2>/dev/null; then
    PROXY_OK=true
fi

if [ "$DOCKER_OK" = true ] && [ "$PROXY_OK" = false ]; then
    echo ""
    echo "ISSUE IDENTIFIED:"
    echo "  Docker container works fine (✓)"
    echo "  But Apache proxy is NOT configured (✗)"
    echo ""
    echo "SOLUTION:"
    echo "  Run the setup script with:"
    echo "  sudo bash /home/delfin/code/setup-production-proxy.sh"
    echo ""
elif [ "$DOCKER_OK" = false ]; then
    echo ""
    echo "ISSUE IDENTIFIED:"
    echo "  Docker container is not responding"
    echo ""
    echo "SOLUTION:"
    echo "  Restart Docker container:"
    echo "  cd /home/delfin/code && docker compose restart"
    echo ""
else
    echo ""
    echo "✓ Everything appears to be configured correctly"
    echo ""
    echo "If you're still getting 404, please provide:"
    echo "  1. The EXACT URL you're accessing in the browser"
    echo "  2. Screenshot of the error if possible"
    echo ""
fi

echo "================================================"
