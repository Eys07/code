# Quick PWA Setup Guide

## 🚀 Get Started in 3 Steps

### Step 1: Start Your Server
```bash
# Using PHP built-in server (for testing only)
php -S localhost:8000

# Or with Docker
docker-compose up
```

### Step 2: Access the App
Open your browser and go to:
```
http://localhost:8000
```

You'll see the PWA status page showing:
- ✅ Service Worker status
- ✅ Manifest status  
- ✅ HTTPS status (will be ⚠️ on HTTP)
- ✅ Network status

### Step 3: Test PWA Features

#### On Desktop (Chrome/Edge):
1. Visit `http://localhost:8000`
2. Look for "Install App" button (bottom-right or in address bar)
3. Click to install
4. App opens in standalone window

#### On Mobile:
1. Visit the URL on your phone
2. **Android (Chrome)**: Menu → "Add to Home screen"
3. **iOS (Safari)**: Share → "Add to Home Screen"

## 📱 Testing Offline Mode

1. Open DevTools (F12)
2. Go to **Network** tab
3. Check "Offline" checkbox
4. Refresh the page
5. You should see the offline page with queued upload functionality

## 🔧 For Production

### HTTPS Setup (Required for PWA)

#### Option 1: Using Let's Encrypt (Recommended)
```bash
# Install certbot
sudo apt-get update
sudo apt-get install certbot python3-certbot-apache

# Get certificate
sudo certbot --apache -d yourdomain.com
```

#### Option 2: Self-Signed (Development Only)
```bash
mkdir ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/server.key -out ssl/server.crt
```

Then update `docker-compose.yml` or Apache config to use SSL.

## 🎨 Customize Icons

### Quick Method (Online Tool):
1. Upload `icons/icon.svg` to https://realfavicongenerator.net/
2. Download generated icons
3. Replace files in `icons/` directory

### Manual Method (ImageMagick):
```bash
./generate-icons.sh
```

## ✅ Verify Installation

Open Chrome DevTools:
```
F12 → Application Tab
├── Manifest: Should show your app details
├── Service Workers: Should show "activated and running"
├── Storage → Cache Storage: Should show cached files
└── Storage → IndexedDB: Should show FileUploadPWA database
```

## 🐛 Common Issues

**"Service Worker registration failed"**
- Check browser console for errors
- Ensure service-worker.js is accessible
- Clear cache and try again

**"Install prompt not showing"**
- PWAs require HTTPS (or localhost)
- Check manifest.json is valid
- Try visiting the site multiple times
- Check Chrome doesn't have "Add to home screen" blocked

**"App not working offline"**
- Check service worker is active
- Verify cache storage has files
- Check Network tab in DevTools

## 📊 Browser Testing

Test in multiple browsers:
- ✅ Chrome/Edge (best support)
- ✅ Firefox (good support, no install prompt)
- ⚠️ Safari (partial support)
- ✅ Mobile browsers

## 🔄 Updating Your PWA

When you make changes:

1. Update version in `service-worker.js`:
```javascript
const CACHE_NAME = 'file-upload-pwa-v2'; // Increment version
```

2. Service worker will auto-update
3. Users will see "New version available" notification
4. They click "Update" to refresh

## 📝 Files Created

```
Your Project/
├── index.html                    # PWA status & launcher page
├── manifest.json                 # PWA manifest
├── service-worker.js             # Service worker (caching, offline)
├── pwa-handler.js                # PWA logic (install, sync, etc.)
├── offline.html                  # Offline fallback page
├── upload_demo.html              # Basic upload (PWA-enabled)
├── upload_extract_demo.html      # Upload + Extract (PWA-enabled)
├── icons/                        # App icons
│   ├── icon.svg                  # Source icon
│   └── icon-*.png                # Generated sizes
├── README_PWA.md                 # Full PWA documentation
└── PWA_SETUP.md                  # This file
```

## 🎯 Next Steps

1. ✅ Test installation on desktop
2. ✅ Test installation on mobile  
3. ✅ Test offline functionality
4. ✅ Customize icons and colors
5. ✅ Set up HTTPS for production
6. ✅ Deploy and test on real domain

---

**Need help?** Check `README_PWA.md` for detailed documentation.

**Ready to upload?** Visit `upload_extract_demo.html` or `upload_demo.html`
