# File Upload System with Duplicate Detection

A comprehensive PHP-based file upload system with advanced duplicate detection and prevention features.

## Features

### ✅ Duplicate Detection

1. **Exact Duplicate Detection**
   - Detects when the same file is uploaded twice
   - Uses SHA-256 hash for content verification
   - Prevents unnecessary storage duplication

2. **Same Content, Different Filename**
   - Identifies files with identical content but different names
   - Prevents duplicate storage of copied files
   - Shows clear message about existing file

3. **Same Filename, Different Content**
   - Detects filename conflicts with different content
   - Prevents accidental file overwrites
   - Suggests using force upload option

4. **Corrupted File Detection**
   - Identifies potentially corrupted uploads (0 bytes or incomplete)
   - Allows replacing corrupted versions with valid files
   - Shows comparison between old and new file sizes

5. **Concurrent Upload Protection**
   - File-based locking mechanism
   - Prevents race conditions during simultaneous uploads
   - Timeout protection (30 seconds default)

### 🔄 Force Upload Option

- Override duplicate detection when needed
- Explicitly marks forced uploads in metadata
- Useful for:
  - Replacing corrupted files
  - Keeping multiple versions intentionally
  - Administrative overrides

### 📊 Upload Management

- **Upload History**: Track all uploads with metadata
- **User Attribution**: Associate uploads with users
- **Timestamp Tracking**: Record upload dates and times
- **File Metadata**: Store original and stored filenames, hashes, sizes
- **Delete Functionality**: Remove uploads with metadata cleanup

## File Structure

```
FileUploadManager.php    - Core upload logic and duplicate detection
upload_handler.php       - API endpoint handler
upload_demo.html         - Interactive web interface demo
README_UPLOAD.md         - This documentation
```

## Installation

1. **Place files in your web directory**
   ```bash
   # Files should be accessible via web server
   FileUploadManager.php
   upload_handler.php
   upload_demo.html
   ```

2. **Create uploads directory**
   ```bash
   mkdir uploads
   chmod 755 uploads
   ```

3. **Configure PHP settings** (optional)
   ```ini
   upload_max_filesize = 50M
   post_max_size = 50M
   max_execution_time = 300
   ```

## Usage

### Web Interface

1. Open `upload_demo.html` in a browser
2. Click upload area or drag and drop a file
3. Optional: Check "Force upload" to override duplicate detection
4. Click "Upload File"
5. View results and upload history

### API Usage

#### Upload File

```bash
# Basic upload
curl -X POST -F "file=@myfile.pdf" \
  http://yourserver/upload_handler.php?action=upload

# Force upload (override duplicates)
curl -X POST -F "file=@myfile.pdf" \
  -F "force_upload=1" \
  http://yourserver/upload_handler.php?action=upload

# With user ID
curl -X POST -F "file=@myfile.pdf" \
  -F "user_id=john_doe" \
  http://yourserver/upload_handler.php?action=upload
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "File uploaded successfully.",
  "data": {
    "id": "upload_6789abcd1234",
    "original_name": "myfile.pdf",
    "stored_name": "myfile.pdf",
    "file_hash": "a1b2c3d4...",
    "file_size": 1024000,
    "mime_type": "application/pdf",
    "uploaded_by": "john_doe",
    "upload_time": "2026-01-17 12:30:45",
    "timestamp": 1737117045,
    "is_forced": false
  }
}
```

**Duplicate Detected (409):**
```json
{
  "success": false,
  "error": "duplicate",
  "message": "⚠️ Duplicate file detected!\n\nThis exact file has already been uploaded...",
  "duplicate_info": {
    "type": "exact_duplicate",
    "description": "Exact same file already uploaded",
    "original_upload": { ... }
  },
  "hint": "Use force_upload option to override this restriction."
}
```

#### Get Upload History

```bash
# All uploads
curl http://yourserver/upload_handler.php?action=history

# Filter by user
curl http://yourserver/upload_handler.php?action=history&user_id=john_doe
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "upload_6789abcd1234",
      "original_name": "document.pdf",
      "stored_name": "document.pdf",
      "file_hash": "a1b2c3...",
      "file_size": 1024000,
      "mime_type": "application/pdf",
      "uploaded_by": "john_doe",
      "upload_time": "2026-01-17 12:30:45",
      "timestamp": 1737117045,
      "is_forced": false
    }
  ],
  "count": 1
}
```

#### Delete Upload

```bash
curl -X POST -F "upload_id=upload_6789abcd1234" \
  http://yourserver/upload_handler.php?action=delete
```

**Response (200):**
```json
{
  "success": true,
  "message": "Upload deleted successfully."
}
```

### PHP Integration

```php
<?php
require_once 'FileUploadManager.php';

// Initialize manager
$uploadManager = new FileUploadManager('uploads/');

// Upload file
$result = $uploadManager->upload($_FILES['file'], [
    'force' => false,
    'user_id' => 'user123'
]);

if ($result['success']) {
    echo "Upload successful: " . $result['data']['stored_name'];
} else {
    if ($result['error'] === 'duplicate') {
        echo "Duplicate detected: " . $result['message'];
        // Show force upload option to user
    } else {
        echo "Error: " . $result['message'];
    }
}

// Get upload history
$history = $uploadManager->getUploadHistory(['user_id' => 'user123']);

// Delete upload
$deleteResult = $uploadManager->deleteUpload('upload_6789abcd1234');
?>
```

## Duplicate Detection Types

### 1. Exact Duplicate
**Scenario**: Upload same file twice
```
File1.pdf (content: ABC123) -> Upload 1 ✅
File1.pdf (content: ABC123) -> Upload 2 ❌ Duplicate!
```

### 2. Same Content, Different Name
**Scenario**: Copy file with new name
```
Report.pdf (content: ABC123) -> Upload 1 ✅
Report_Copy.pdf (content: ABC123) -> Upload 2 ❌ Same content!
```

### 3. Same Name, Different Content
**Scenario**: Different file with same name
```
Document.pdf (content: ABC123) -> Upload 1 ✅
Document.pdf (content: XYZ789) -> Upload 2 ❌ Name conflict!
```

### 4. Corrupted File Replacement
**Scenario**: Upload corrupted, then valid file
```
Image.jpg (size: 0 bytes) -> Upload 1 ✅ (corrupted)
Image.jpg (size: 500KB) -> Upload 2 ⚠️ Replacing corrupted
```

## Concurrent Upload Handling

The system uses file-based locking to prevent issues when multiple users upload simultaneously:

1. Each upload request acquires an exclusive lock
2. Other requests wait (up to 30 seconds)
3. Metadata updates are atomic
4. Lock is always released (even on errors)

## Security Considerations

1. **File Validation**: Validates upload errors and file integrity
2. **Hash Verification**: SHA-256 prevents collision attacks
3. **Atomic Operations**: File locks prevent race conditions
4. **Path Safety**: Uses basename() to prevent directory traversal
5. **Metadata Isolation**: Stores tracking data separately from files

## Configuration

### Change Upload Directory

```php
$uploadManager = new FileUploadManager('custom/path/');
```

### Adjust Lock Timeout

Edit `FileUploadManager.php`:
```php
private function acquireLock($timeout = 60) { // 60 seconds
```

### Maximum File Size

Edit `php.ini` or `.htaccess`:
```ini
upload_max_filesize = 100M
post_max_size = 100M
```

## Error Handling

| Error Code | HTTP Status | Description |
|------------|-------------|-------------|
| duplicate | 409 | Duplicate file detected |
| invalid_parameters | 400 | Invalid upload parameters |
| file_too_large | 400 | File exceeds size limit |
| upload_incomplete | 400 | Upload was interrupted |
| corrupted_file | 400 | File is corrupted (0 bytes) |
| upload_failed | 400 | Failed to save file |
| not_found | 404 | Upload ID not found |

## Troubleshooting

### Uploads directory not writable
```bash
chmod 755 uploads/
chown www-data:www-data uploads/  # Linux/Apache
```

### Lock timeout errors
- Increase timeout in `acquireLock()` method
- Check disk I/O performance
- Verify file permissions

### Duplicate detection not working
- Ensure metadata file is writable
- Check SHA-256 is available: `hash_algos()`
- Verify file upload completes successfully

## Testing Scenarios

```bash
# Test 1: Upload same file twice
curl -F "file=@test.pdf" http://localhost/upload_handler.php?action=upload
curl -F "file=@test.pdf" http://localhost/upload_handler.php?action=upload

# Test 2: Upload with force option
curl -F "file=@test.pdf" -F "force_upload=1" \
  http://localhost/upload_handler.php?action=upload

# Test 3: Concurrent uploads
for i in {1..5}; do
  curl -F "file=@test.pdf" http://localhost/upload_handler.php?action=upload &
done
wait

# Test 4: Different files, same name
curl -F "file=@file1.txt" http://localhost/upload_handler.php?action=upload
curl -F "file=@file2.txt" http://localhost/upload_handler.php?action=upload
```

## License

This is a demonstration system. Customize and use according to your needs.

## Support

For issues or questions:
1. Check this README
2. Review error messages
3. Check PHP error logs
4. Verify file permissions

---

**Created**: January 2026  
**Version**: 1.0.0
