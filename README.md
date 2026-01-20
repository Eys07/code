# File Upload System - Progressive Web App

## 📱 Modern File Upload with PWA Features

A complete file upload system with duplicate detection, text extraction (OCR), and Progressive Web App capabilities.

---

## ✨ Key Features

### 🔐 File Upload
- **Duplicate Detection** - SHA-256 hash-based duplicate checking
- **Force Upload** - Override duplicate restrictions
- **Upload History** - Track all uploads with metadata
- **Concurrent Upload Protection** - File locking system

### 📄 Text Extraction
- **PDF Text Extraction** - Native text from PDFs
- **DOCX Support** - Extract from Word documents
- **OCR Technology** - Tesseract OCR for scanned documents & images
- **Multi-language** - Support for 6+ languages
- **Image Support** - JPG, PNG, TIFF

### 📱 Progressive Web App
- **Installable** - Desktop & mobile app
- **Offline Mode** - Works without internet
- **Background Sync** - Auto-sync failed uploads
- **Fast Loading** - Service worker caching
- **Auto-Update** - Version management

---

## 🚀 Quick Start

### 1. Start the Server
```bash
php -S localhost:8000
```

### 2. Open Your Browser
```
http://localhost:8000
```

### 3. Choose Your Interface
- **index.html** - PWA status dashboard
- **upload_demo.html** - Basic upload with duplicate detection
- **upload_extract_demo.html** - Upload + text extraction

---

## 📁 Project Structure

```
/
├── 📱 PWA Core
│   ├── manifest.json              # App configuration
│   ├── service-worker.js          # Caching & offline
│   ├── pwa-handler.js             # PWA features
│   └── .htaccess                  # Server config
│
├── 🎨 User Interface
│   ├── index.html                 # PWA launcher
│   ├── upload_demo.html           # Basic upload
│   ├── upload_extract_demo.html   # Upload + extract
│   └── offline.html               # Offline fallback
│
├── ⚙️ Backend
│   ├── FileUploadManager.php      # Upload logic
│   ├── TextExtractor.php          # Extraction logic
│   └── upload_handler.php         # API endpoint
│
├── 🖼️ Assets
│   └── icons/                     # PWA icons (9 sizes)
│
└── 📖 Documentation
    ├── START_HERE.md              # Quick start
    ├── PWA_SETUP.md               # PWA setup
    ├── README_PWA.md              # PWA docs
    ├── README_UPLOAD.md           # Upload docs
    ├── README_TEXT_EXTRACTION.md  # Extraction docs
    └── INSTALLATION_CHECKLIST.txt # Testing checklist
```

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| **START_HERE.md** | Quick start guide - read this first! |
| **PWA_SETUP.md** | PWA setup & configuration |
| **README_PWA.md** | Complete PWA documentation |
| **README_UPLOAD.md** | File upload system guide |
| **README_TEXT_EXTRACTION.md** | Text extraction guide |
| **INSTALLATION_CHECKLIST.txt** | Testing checklist |

---

## 🎯 Use Cases

### Basic File Upload
```
1. Visit upload_demo.html
2. Select or drag file
3. Click "Upload File"
4. View upload history
```

### Upload with Text Extraction
```
1. Visit upload_extract_demo.html
2. Select PDF, DOCX, or image
3. Enable OCR (if needed)
4. Click "Upload & Extract"
5. View extracted text
6. Copy or download text
```

### Install as App
```
1. Visit index.html
2. Click "Install App" button
3. Launch from desktop/home screen
4. Use offline!
```

---

## 🔧 Requirements

### Server Requirements
- PHP 7.4 or higher
- Apache/Nginx web server
- Write permissions for uploads directory

### Optional (for text extraction)
- Tesseract OCR (for images)
- Poppler utils (for PDFs)
- ImageMagick (for image processing)
- PHP ZIP extension (for DOCX)

### PWA Requirements
- HTTPS (production only, localhost works for testing)
- Modern browser (Chrome, Edge, Firefox, Safari)

---

## 🌐 Browser Support

| Feature | Chrome | Edge | Firefox | Safari |
|---------|--------|------|---------|--------|
| File Upload | ✅ | ✅ | ✅ | ✅ |
| Text Extraction | ✅ | ✅ | ✅ | ✅ |
| Service Worker | ✅ | ✅ | ✅ | ✅ |
| Install Prompt | ✅ | ✅ | ❌ | ⚠️ |
| Offline Mode | ✅ | ✅ | ✅ | ✅ |
| Background Sync | ✅ | ✅ | ❌ | ❌ |

✅ Full support | ⚠️ Partial support | ❌ Not supported

---

## 🎨 Customization

### App Name & Colors
Edit `manifest.json`:
```json
{
  "name": "Your App Name",
  "short_name": "YourApp",
  "theme_color": "#yourcolor",
  "background_color": "#yourcolor"
}
```

### Custom Icons
1. Edit `icons/icon.svg`
2. Run `./generate-icons.sh` (requires ImageMagick)
3. Or use https://realfavicongenerator.net/

### Upload Directory
Edit `FileUploadManager.php`:
```php
$manager = new FileUploadManager('your/upload/path/');
```

---

## 🔒 Security

- ✅ File type validation
- ✅ Size limit enforcement
- ✅ SHA-256 hash verification
- ✅ Concurrent upload protection
- ✅ HTTPS support (production)
- ✅ Secure file storage

---

## 🚀 Production Deployment

### 1. Set up HTTPS
```bash
# Using Let's Encrypt
sudo certbot --apache -d yourdomain.com
```

### 2. Update Configuration
- Edit `manifest.json` - Update start_url
- Edit `.htaccess` - Enable HTTPS redirect
- Configure PHP upload limits if needed

### 3. Deploy Files
```bash
# Upload all files to server
rsync -av --exclude 'clone' ./ user@server:/var/www/html/
```

### 4. Test
- Visit your domain
- Install PWA
- Test offline mode
- Verify uploads work

---

## 🧪 Testing

### Local Testing
```bash
# Start server
php -S localhost:8000

# Open browser
open http://localhost:8000

# Run through checklist
cat INSTALLATION_CHECKLIST.txt
```

### DevTools
```
Chrome DevTools (F12)
├── Application → Service Workers (check status)
├── Application → Manifest (verify config)
├── Application → Cache Storage (check caches)
└── Application → IndexedDB (verify database)
```

### Offline Testing
```
1. DevTools → Network → Offline
2. Refresh page
3. Test upload queuing
4. Disable offline
5. Verify sync
```

---

## 🐛 Troubleshooting

### Service Worker Issues
- Clear cache: DevTools → Application → Clear Storage
- Check console for errors
- Verify service-worker.js is accessible

### Install Button Missing
- Requires HTTPS (or localhost)
- Check manifest.json is valid
- Service worker must be active
- May need multiple visits

### Upload Failures
- Check PHP upload limits
- Verify directory permissions
- Check server logs
- Test file size/type

---

## 📊 Features Comparison

| Feature | upload_demo.html | upload_extract_demo.html |
|---------|------------------|--------------------------|
| File Upload | ✅ | ✅ |
| Duplicate Detection | ✅ | ✅ |
| Force Upload | ✅ | ✅ |
| Upload History | ✅ | ✅ |
| Text Extraction | ❌ | ✅ |
| OCR Support | ❌ | ✅ |
| PDF Support | ❌ | ✅ |
| DOCX Support | ❌ | ✅ |
| Image Support | ❌ | ✅ |
| Multi-language OCR | ❌ | ✅ |
| PWA Features | ✅ | ✅ |
| Offline Mode | ✅ | ✅ |

---

## 🎓 Learning Resources

- [MDN: Progressive Web Apps](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
- [Web.dev: PWA](https://web.dev/learn/pwa/)
- [Service Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)
- [Tesseract OCR](https://github.com/tesseract-ocr/tesseract)

---

## 📄 License

This project is provided as-is for educational and commercial use.

---

## 🙏 Credits

Built with:
- PHP for backend
- Vanilla JavaScript for frontend
- Service Workers for PWA features
- IndexedDB for offline storage
- Tesseract OCR for text extraction

---

## 📞 Support

### Documentation
- Check START_HERE.md for quick start
- See PWA_SETUP.md for PWA configuration
- Review INSTALLATION_CHECKLIST.txt for testing

### Debugging
- Use Chrome DevTools (F12)
- Check browser console
- Review server logs
- Test on different browsers

---

**Made with ❤️ - Ready to use as a Progressive Web App!**

🚀 Get started: `php -S localhost:8000` then visit http://localhost:8000
