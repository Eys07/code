// PWA Handler - Manages service worker registration and offline functionality

class PWAHandler {
  constructor() {
    this.isOnline = navigator.onLine;
    this.pendingUploads = [];
    this.dbName = 'FileUploadPWA';
    this.dbVersion = 1;
    this.db = null;
    
    this.init();
  }

  async init() {
    // Initialize IndexedDB for offline storage
    await this.initDB();
    
    // Register service worker
    this.registerServiceWorker();
    
    // Setup online/offline listeners
    this.setupNetworkListeners();
    
    // Setup install prompt
    this.setupInstallPrompt();
    
    // Load pending uploads
    await this.loadPendingUploads();
  }

  async initDB() {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open(this.dbName, this.dbVersion);
      
      request.onerror = () => reject(request.error);
      request.onsuccess = () => {
        this.db = request.result;
        resolve(this.db);
      };
      
      request.onupgradeneeded = (event) => {
        const db = event.target.result;
        
        // Create uploads store
        if (!db.objectStoreNames.contains('uploads')) {
          const store = db.createObjectStore('uploads', { keyPath: 'id', autoIncrement: true });
          store.createIndex('timestamp', 'timestamp', { unique: false });
          store.createIndex('status', 'status', { unique: false });
        }
      };
    });
  }

  registerServiceWorker() {
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', async () => {
        try {
          const registration = await navigator.serviceWorker.register('/service-worker.js');
          console.log('✅ ServiceWorker registered:', registration.scope);
          
          // Check for updates
          registration.addEventListener('updatefound', () => {
            const newWorker = registration.installing;
            newWorker.addEventListener('statechange', () => {
              if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
                this.showUpdateNotification();
              }
            });
          });
          
          // Listen for messages from service worker
          navigator.serviceWorker.addEventListener('message', (event) => {
            this.handleServiceWorkerMessage(event.data);
          });
          
        } catch (error) {
          console.error('❌ ServiceWorker registration failed:', error);
        }
      });
    }
  }

  setupNetworkListeners() {
    window.addEventListener('online', () => {
      this.isOnline = true;
      this.updateOnlineStatus(true);
      this.syncPendingUploads();
    });

    window.addEventListener('offline', () => {
      this.isOnline = false;
      this.updateOnlineStatus(false);
    });

    // Initial status
    this.updateOnlineStatus(this.isOnline);
  }

  updateOnlineStatus(isOnline) {
    const statusBar = document.getElementById('networkStatus');
    if (!statusBar) {
      // Create status bar if it doesn't exist
      const bar = document.createElement('div');
      bar.id = 'networkStatus';
      bar.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        padding: 10px;
        text-align: center;
        font-weight: bold;
        z-index: 10000;
        transition: all 0.3s;
      `;
      document.body.prepend(bar);
    }

    const bar = document.getElementById('networkStatus');
    if (isOnline) {
      bar.textContent = '🟢 Online - Ready to upload';
      bar.style.background = '#48bb78';
      bar.style.color = 'white';
      setTimeout(() => {
        bar.style.display = 'none';
      }, 3000);
    } else {
      bar.textContent = '🔴 Offline - Uploads will be queued';
      bar.style.background = '#f56565';
      bar.style.color = 'white';
      bar.style.display = 'block';
    }
  }

  setupInstallPrompt() {
    let deferredPrompt;

    window.addEventListener('beforeinstallprompt', (e) => {
      e.preventDefault();
      deferredPrompt = e;
      this.showInstallButton(deferredPrompt);
    });

    window.addEventListener('appinstalled', () => {
      console.log('✅ PWA installed successfully');
      deferredPrompt = null;
      this.hideInstallButton();
    });
  }

  showInstallButton(deferredPrompt) {
    const installBtn = document.getElementById('installBtn');
    if (installBtn) {
      installBtn.style.display = 'inline-block';
      installBtn.onclick = async () => {
        deferredPrompt.prompt();
        const { outcome } = await deferredPrompt.userChoice;
        console.log(`Install prompt outcome: ${outcome}`);
        deferredPrompt = null;
      };
    } else {
      // Create install button dynamically
      const btn = document.createElement('button');
      btn.id = 'installBtn';
      btn.className = 'btn btn-secondary';
      btn.textContent = '📱 Install App';
      btn.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 9999;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
      `;
      btn.onclick = async () => {
        deferredPrompt.prompt();
        const { outcome } = await deferredPrompt.userChoice;
        console.log(`Install prompt outcome: ${outcome}`);
        if (outcome === 'accepted') {
          btn.remove();
        }
      };
      document.body.appendChild(btn);
    }
  }

  hideInstallButton() {
    const installBtn = document.getElementById('installBtn');
    if (installBtn) {
      installBtn.remove();
    }
  }

  async savePendingUpload(fileData, options) {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction(['uploads'], 'readwrite');
      const store = transaction.objectStore('uploads');
      
      const upload = {
        fileData: fileData,
        options: options,
        timestamp: Date.now(),
        status: 'pending'
      };
      
      const request = store.add(upload);
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error);
    });
  }

  async loadPendingUploads() {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction(['uploads'], 'readonly');
      const store = transaction.objectStore('uploads');
      const index = store.index('status');
      const request = index.getAll('pending');
      
      request.onsuccess = () => {
        this.pendingUploads = request.result;
        console.log(`📋 Loaded ${this.pendingUploads.length} pending uploads`);
        resolve(this.pendingUploads);
      };
      request.onerror = () => reject(request.error);
    });
  }

  async syncPendingUploads() {
    if (!this.isOnline || this.pendingUploads.length === 0) {
      return;
    }

    console.log(`🔄 Syncing ${this.pendingUploads.length} pending uploads...`);
    
    for (const upload of this.pendingUploads) {
      try {
        // Attempt to upload
        const formData = new FormData();
        // Reconstruct FormData from saved data
        Object.keys(upload.fileData).forEach(key => {
          formData.append(key, upload.fileData[key]);
        });

        const response = await fetch('upload_handler.php?action=upload', {
          method: 'POST',
          body: formData
        });

        if (response.ok) {
          await this.removePendingUpload(upload.id);
          console.log('✅ Upload synced successfully');
        }
      } catch (error) {
        console.error('❌ Failed to sync upload:', error);
      }
    }

    await this.loadPendingUploads();
  }

  async removePendingUpload(id) {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction(['uploads'], 'readwrite');
      const store = transaction.objectStore('uploads');
      const request = store.delete(id);
      
      request.onsuccess = () => resolve();
      request.onerror = () => reject(request.error);
    });
  }

  handleServiceWorkerMessage(data) {
    switch (data.type) {
      case 'SYNC_UPLOADS':
        this.syncPendingUploads();
        break;
      case 'CACHE_UPDATED':
        console.log('Cache updated');
        break;
      default:
        console.log('Unknown message from service worker:', data);
    }
  }

  showUpdateNotification() {
    const notification = document.createElement('div');
    notification.style.cssText = `
      position: fixed;
      top: 60px;
      left: 50%;
      transform: translateX(-50%);
      background: #4299e1;
      color: white;
      padding: 15px 25px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.3);
      z-index: 10001;
      display: flex;
      gap: 15px;
      align-items: center;
    `;
    
    notification.innerHTML = `
      <span>🔄 New version available!</span>
      <button onclick="location.reload()" style="
        background: white;
        color: #4299e1;
        border: none;
        padding: 5px 15px;
        border-radius: 5px;
        cursor: pointer;
        font-weight: bold;
      ">Update</button>
    `;
    
    document.body.appendChild(notification);
  }

  // Request notification permission
  async requestNotificationPermission() {
    if ('Notification' in window && Notification.permission === 'default') {
      const permission = await Notification.permission();
      return permission === 'granted';
    }
    return Notification.permission === 'granted';
  }

  // Show notification
  showNotification(title, options) {
    if ('Notification' in window && Notification.permission === 'granted') {
      new Notification(title, {
        icon: '/icons/icon-192x192.png',
        badge: '/icons/icon-72x72.png',
        ...options
      });
    }
  }
}

// Initialize PWA Handler
let pwaHandler;
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    pwaHandler = new PWAHandler();
  });
} else {
  pwaHandler = new PWAHandler();
}
