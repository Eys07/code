# ORDINANCES MULTIPLE UPLOAD - TROUBLESHOOTING GUIDE

## Date: 2026-02-04

## Current Status
- ✅ Resolutions: Multiple uploads WORKING
- ✅ Minutes: Multiple uploads WORKING
- ❌ Ordinances: Multiple uploads NOT WORKING (investigating)

## Changes Made So Far

### 1. HTML Input Field (/home/delfin/code/clone/eFIND/admin/ordinances.php)
- Line ~1786: Added `name="image_file[]"` and `multiple` attribute
- Added file counter display to show number of files selected
- Changed `onchange="processFileWithAutoFill"` to `onchange="processFilesWithAutoFill"`

### 2. PHP Backend
- Line ~460: Changed condition from `is_array($_FILES['image_file']['tmp_name'])` to `!empty($_FILES['image_file']['name'][0])`
- Added check for empty file names: `empty($_FILES['image_file']['name'][$key])`
- Both Add and Update handlers modified

### 3. JavaScript Functions
- Line ~2506: Added `processFilesWithAutoFill()` function
- Added file counter display in the function
- Line ~3027: Added `processFiles()` function for edit modal

## Debug Steps to Test

### Step 1: Check File Input
Open browser console and run:
```javascript
document.getElementById('image_file').hasAttribute('multiple')
// Should return: true

document.getElementById('image_file').name
// Should return: "image_file[]"
```

### Step 2: Test File Selection
1. Open "Add New Ordinance" modal
2. Click file input
3. Select 2-3 images (use Ctrl+Click to select multiple)
4. Check if file counter shows correct number
5. Check browser console for any JavaScript errors

### Step 3: Check $_FILES Structure
Use the debug script at: `/home/delfin/code/clone/eFIND/admin/test_upload_debug.php`
1. Access: http://your-domain/admin/test_upload_debug.php
2. Select multiple files
3. Submit form
4. Check the output to see $_FILES structure

### Step 4: Compare with Resolutions
Both should be identical now. Check:
```bash
cd /home/delfin/code/clone/eFIND/admin
diff <(grep -A20 "if (isset(\$_FILES\['image_file'\])" ordinances.php | head -25) \
     <(grep -A20 "if (isset(\$_FILES\['image_file'\])" resolutions.php | head -25)
```

## Possible Issues to Check

### Issue 1: Browser Cache
- Clear browser cache
- Hard refresh (Ctrl+Shift+R)
- Try incognito/private mode

### Issue 2: JavaScript Errors
Open browser DevTools (F12) and check:
- Console tab for errors
- Network tab to see if files are being posted

### Issue 3: PHP Session/Errors
Check PHP error log:
```bash
tail -f /var/log/php/error.log
# or
tail -f /var/log/apache2/error.log
```

### Issue 4: Form Encoding
Verify form has proper encoding:
```html
<form method="POST" enctype="multipart/form-data">
```

### Issue 5: File Size Limits
Check php.ini:
```bash
php -i | grep -E "upload_max_filesize|post_max_size|max_file_uploads"
```

## Testing Checklist

When testing, try:
- [ ] Single file upload
- [ ] 2 files upload
- [ ] 5 files upload  
- [ ] Mix of JPG and PNG
- [ ] Mix of images and PDF
- [ ] Large files (close to 5MB each)
- [ ] Test both Add and Edit modals

## What Should Happen

### Expected Behavior:
1. User clicks file input
2. Selects multiple files (Ctrl+Click or Shift+Click)
3. File counter shows: "X file(s) selected"
4. Processing indicator shows
5. Each file is processed with OCR
6. Combined text auto-fills form
7. On submit, all files upload to MinIO
8. URLs stored as pipe-separated: `url1|url2|url3`

### Current Behavior (Ordinances):
**Please describe what actually happens:**
- [ ] Files can be selected but don't upload
- [ ] Only first file uploads
- [ ] No files upload at all
- [ ] JavaScript error appears
- [ ] Other: _________________

## Files to Check

1. `/home/delfin/code/clone/eFIND/admin/ordinances.php` (main file)
2. `/home/delfin/code/clone/eFIND/admin/test_upload_debug.php` (debug script)
3. `/home/delfin/code/clone/eFIND/admin/includes/minio_helper.php` (MinIO upload)

## Next Steps

If still not working, please provide:
1. Browser console errors (screenshot)
2. Network tab showing POST request (screenshot)
3. PHP error log entries
4. Output from test_upload_debug.php
5. Exact description of what happens when you try to upload

## Questions to Answer

1. Can you select multiple files? (file picker shows multiple files)
2. Does the file counter show? (e.g., "3 file(s) selected")
3. Does OCR processing start?
4. Do you see any error messages?
5. What exactly happens when you click "Add Ordinance"?
