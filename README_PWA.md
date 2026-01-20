# Progressive Web App (PWA) Implementation

This file upload system has been enhanced with **Progressive Web App** capabilities, making it installable and functional offline.

## 🚀 Features

### ✅ Installable
- Install on desktop or mobile devices
- Works like a native app
- Appears in app drawer/home screen
- Standalone window (no browser UI)

### 📡 Offline Support
- **Cache-first** for static assets (HTML, CSS, JS)
- **Network-first** for API calls with offline fallback
- Queued uploads when offline (syncs when back online)
- Automatic retry of failed uploads
- Online/offline status indicator

### 🔔 Notifications (Optional)
- Upload completion notifications
- Sync status updates
- Update available alerts

### 🔄 Auto-Update
- Automatic service worker updates
- User-friendly update prompt
- Seamless version transitions

## 📁 PWA Files

```
/
├── manifest.json           # App manifest (name, icons, theme)
├── service-worker.js       # Service worker (caching, offline)
├── pwa-handler.js          # PWA logic (IndexedDB, sync, install)
└── icons/                  # App icons (various sizes)
    ├── icon-72x72.png
    ├── icon-96x96.png
    ├── icon-128x128.png
    ├── icon-144x144.png
    ├── icon-152x152.png
    ├── icon-192x192.png
    ├── icon-384x384.png
    ├── icon-512x512.png
    └── icon.svg            # Source SVG
```

## 🛠️ Setup & Installation

### 1. Generate Icons (Optional)
If you have ImageMagick installed:
```bash
./generate-icons.sh
```

Or use the SVG file (`icons/icon.svg`) with online converters:
- https://realfavicongenerator.net/
- https://www.favicon-generator.org/

### 2. HTTPS Requirement
PWAs require HTTPS. Update your `docker-compose.yml`:

```yaml
services:
  web:
    image: php:8.1-apache
    ports:
      - "443:443"
      - "80:80"
    volumes:
      - ./:/var/www/html
      - ./ssl:/etc/apache2/ssl  # SSL certificates
    environment:
      - APACHE_HTTPS=on
```

### 3. Enable SSL in Apache
Create SSL certificates (for development):
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/server.key -out ssl/server.crt
```

### 4. Test Locally
1. Start your server with HTTPS
2. Open Chrome/Edge DevTools > Application > Service Workers
3. Check "Update on reload" for development
4. Visit your app and look for install prompt

## 🎯 How It Works

### Service Worker Caching
```javascript
// Cache-first for static assets
- HTML, CSS, JavaScript files
- App icons
- Fonts

// Network-first for API calls
- upload_handler.php
- Real-time data
- Falls back to cache if offline
```

### Offline Upload Queue
When offline:
1. Upload attempt is saved to **IndexedDB**
2. User sees "Offline - uploads will be queued" message
3. File data stored locally

When back online:
1. Automatic sync triggered
2. Queued uploads sent to server
3. User notified of sync completion

### Install Process
1. User visits app (meets PWA criteria)
2. Browser shows install prompt
3. User clicks "Install App" button
4. App installed to device
5. Can launch from home screen/start menu

## 📱 Testing

### Desktop (Chrome/Edge)
1. Visit app via HTTPS
2. Click "Install App" button in bottom-right
3. App appears in system applications

### Mobile (Android/iOS)
**Android:**
1. Visit in Chrome
2. Tap "Add to Home Screen"
3. App appears in app drawer

**iOS:**
1. Visit in Safari
2. Tap Share > "Add to Home Screen"
3. App appears on home screen

### DevTools Testing
```
Chrome DevTools > Application Tab
├── Manifest          # Check manifest.json
├── Service Workers   # Debug service worker
├── Storage           # View IndexedDB (queued uploads)
└── Cache Storage     # Inspect cached assets
```

## 🔧 Configuration

### Customize App Info
Edit `manifest.json`:
```json
{
  "name": "Your App Name",
  "short_name": "YourApp",
  "theme_color": "#yourcolor",
  "background_color": "#yourcolor"
}
```

### Adjust Cache Strategy
Edit `service-worker.js`:
```javascript
const CACHE_NAME = 'your-app-v1';  // Update version
const STATIC_ASSETS = [
  // Add/remove files to cache
];
```

### Offline Timeout
Edit `pwa-handler.js`:
```javascript
// Adjust sync retry logic
async syncPendingUploads() {
  // Custom retry logic here
}
```

## 🎨 Customizing Icons

### Current Design
- Gradient background (#667eea to #764ba2)
- White file icon with upload arrow
- Rounded corners (80px radius)

### To Customize
1. Edit `icons/icon.svg`
2. Change colors, shapes, or add your logo
3. Run `./generate-icons.sh` or use online converter
4. Replace PNG files in `icons/` directory

## 📊 Browser Support

| Feature | Chrome | Edge | Firefox | Safari | Mobile |
|---------|--------|------|---------|--------|--------|
| Service Worker | ✅ | ✅ | ✅ | ✅ | ✅ |
| Install Prompt | ✅ | ✅ | ❌ | ⚠️ | ✅ |
| Push Notifications | ✅ | ✅ | ✅ | ⚠️ | ✅ |
| Background Sync | ✅ | ✅ | ❌ | ❌ | ✅ |
| IndexedDB | ✅ | ✅ | ✅ | ✅ | ✅ |

⚠️ = Partial support  
❌ = Not supported

## 🐛 Troubleshooting

### Service Worker Not Registering
```javascript
// Check browser console for errors
// Ensure HTTPS is enabled
// Clear cache: DevTools > Application > Clear Storage
```

### Install Prompt Not Showing
- Requires HTTPS
- Requires valid manifest.json
- Requires service worker
- May need multiple visits to site
- Check: DevTools > Application > Manifest

### Uploads Not Syncing
```javascript
// Check IndexedDB: DevTools > Application > IndexedDB
// Check network status in PWA handler
// Verify upload_handler.php is accessible
```

### Icons Not Displaying
- Check manifest.json icon paths
- Ensure PNG files exist in /icons/
- Clear browser cache
- Reinstall app

## 🚀 Production Deployment

1. **Generate proper icons** from SVG
2. **Get SSL certificate** (Let's Encrypt)
3. **Update manifest.json** with production URLs
4. **Test on real devices** (not just localhost)
5. **Update service worker** version on each deploy
6. **Monitor service worker** updates in production

## 📝 Best Practices

- ✅ Update `CACHE_NAME` when deploying changes
- ✅ Test offline functionality before deploying
- ✅ Keep service worker logic simple
- ✅ Don't cache user-specific data
- ✅ Provide clear offline feedback
- ✅ Test on multiple devices/browsers
- ✅ Monitor service worker errors in production

## 🔐 Security Notes

- Service workers only work on HTTPS
- Cached data is accessible offline
- Don't cache sensitive user data
- Validate all uploads server-side
- Use appropriate cache expiration

## 📚 Additional Resources

- [MDN: Progressive Web Apps](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
- [Google PWA Checklist](https://web.dev/pwa-checklist/)
- [Service Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)
- [Web App Manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest)

---

**Your file upload system is now a fully functional PWA! 🎉**
