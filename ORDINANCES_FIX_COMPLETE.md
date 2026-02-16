# ORDINANCES MULTIPLE UPLOAD FIX - FINAL VERSION

## Date: 2026-02-04 01:33 AM

## Problem Statement
Multiple file uploads work in Resolutions and Minutes, but NOT in Ordinances.

## All Changes Made

### 1. HTML Form - Add Modal (Line ~1781-1795)
**File:** `/home/delfin/code/clone/eFIND/admin/ordinances.php`

```html
<div class="mb-3">
    <label class="form-label">Image File (JPG, PNG, PDF)</label>
    <div class="file-upload">
        <input type="file" class="form-control" id="image_file" 
               name="image_file[]" 
               accept=".jpg,.jpeg,.png,.pdf" 
               multiple 
               onchange="processFilesWithAutoFill(this)">
        <small class="text-muted">Max file size: 5MB per file. You can upload multiple images (e.g., page 1, page 2).</small>
        <div id="fileCount" class="mt-1" style="display: none;">
            <span class="badge bg-info"><span id="fileCountNumber">0</span> file(s) selected</span>
        </div>
    </div>
    <!-- OCR processing indicator -->
</div>
```

**Key Changes:**
- `name="image_file"` → `name="image_file[]"` (array notation)
- Added `multiple` attribute
- Changed `onchange` from `processFileWithAutoFill` to `processFilesWithAutoFill`
- Added file counter display

### 2. HTML Form - Edit Modal (Line ~1850-1860)
```html
<input type="file" class="form-control" id="editImageFile" 
       name="image_file[]" 
       accept=".jpg,.jpeg,.png,.pdf" 
       multiple 
       onchange="processFiles(this, 'edit')">
```

**Key Changes:**
- `name="image_file"` → `name="image_file[]"`
- Added `multiple` attribute  
- Changed `onchange` from `processFile` to `processFiles`

### 3. PHP Backend - Add Handler (Line ~458-495)

```php
// Handle multiple file uploads to MinIO
$image_path = null;
if (isset($_FILES['image_file']) && !empty($_FILES['image_file']['name'][0])) {
    $minioClient = new MinioS3Client();
    $image_paths = [];
    
    foreach ($_FILES['image_file']['tmp_name'] as $key => $tmpName) {
        // Skip if no file or error
        if (empty($_FILES['image_file']['name'][$key]) || $_FILES['image_file']['error'][$key] !== UPLOAD_ERR_OK) {
            continue;
        }
        
        // Validate file type
        if (!isValidOrdinanceDocument(['type' => $_FILES['image_file']['type'][$key]])) {
            $_SESSION['error'] = "Invalid file type. Only JPG, PNG, GIF, BMP, PDF, or DOCX files are allowed.";
            header("Location: ordinances.php");
            exit();
        }
        
        // Generate unique filename
        $fileName = basename($_FILES['image_file']['name'][$key]);
        $fileExt = pathinfo($fileName, PATHINFO_EXTENSION);
        $uniqueFileName = uniqid() . '_' . time() . '_' . $key . '.' . $fileExt;
        $objectName = 'ordinances/' . date('Y/m/') . $uniqueFileName;
        
        // Upload to MinIO
        $contentType = MinioS3Client::getMimeType($fileName);
        $uploadResult = $minioClient->uploadFile($tmpName, $objectName, $contentType);
        
        if ($uploadResult['success']) {
            $image_paths[] = $uploadResult['url'];
            logDocumentUpload('ordinance', $fileName, $uniqueFileName);
        } else {
            $_SESSION['error'] = "Failed to upload file: $fileName. " . $uploadResult['error'];
            header("Location: ordinances.php");
            exit();
        }
    }
    
    // Combine URLs with pipe separator
    if (!empty($image_paths)) {
        $image_path = implode('|', $image_paths);
    }
}
```

**Key Changes:**
- Changed condition from `is_array($_FILES['image_file']['tmp_name'])` to `!empty($_FILES['image_file']['name'][0])`
- Added `foreach` loop to process multiple files
- Added check: `empty($_FILES['image_file']['name'][$key])`
- Store multiple URLs as pipe-separated: `url1|url2|url3`

### 4. PHP Backend - Update Handler (Line ~527-564)
Same changes as Add Handler, but for update operation.

### 5. JavaScript - processFilesWithAutoFill() (Line ~2506-2665)

```javascript
async function processFilesWithAutoFill(input) {
    const files = input.files;
    
    // Show file count
    const fileCountDiv = document.getElementById('fileCount');
    const fileCountNumber = document.getElementById('fileCountNumber');
    if (fileCountDiv && fileCountNumber && files.length > 0) {
        fileCountNumber.textContent = files.length;
        fileCountDiv.style.display = 'block';
    }
    
    if (!files || files.length === 0) return;
    
    // Initialize progress indicators
    const autoFillSection = document.getElementById('autoFillSection');
    const autoFillProgressBar = document.getElementById('autoFillProgressBar');
    const processingElement = document.getElementById('ocrProcessing');
    
    autoFillSection.style.display = 'block';
    processingElement.style.display = 'block';
    
    try {
        let combinedText = '';
        let processedFiles = 0;
        
        // Process each file
        for (let i = 0; i < files.length; i++) {
            const file = files[i];
            const fileExtension = file.name.split('.').pop().toLowerCase();
            
            if (imageExtensions.includes(fileExtension)) {
                // Perform OCR on image
                const { data: { text } } = await Tesseract.recognize(file, 'eng');
                if (text && text.trim().length > 0) {
                    combinedText += cleanOcrText(text) + '\n\n---\n\n';
                }
            } else if (['pdf', 'docx', 'doc'].includes(fileExtension)) {
                // Server-side extraction for PDF/DOCX
                const formData = new FormData();
                formData.append('file', file);
                formData.append('extract_text', '1');
                
                const response = await fetch('../upload_handler.php?action=upload', {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                if (result.success && result.extraction && result.extraction.text) {
                    combinedText += cleanOcrText(result.extraction.text) + '\n\n---\n\n';
                }
            }
            
            processedFiles++;
            autoFillProgressBar.style.width = `${(processedFiles / files.length) * 100}%`;
        }
        
        // Auto-fill form with combined text
        if (combinedText.trim().length > 0) {
            const detectedFields = analyzeDocumentContent(combinedText);
            updateFormWithDetectedData(detectedFields);
            showAutoFillResults(detectedFields);
        }
        
    } catch (error) {
        console.error('Error:', error);
        processingElement.innerHTML = `<div class="alert alert-danger">Error: ${error.message}</div>`;
    }
}
```

### 6. JavaScript - processFiles() (Line ~3027-3172)
Similar to `processFilesWithAutoFill()` but for edit modal.

## Verification Checklist

Run these checks to verify the fix:

```bash
cd /home/delfin/code/clone/eFIND/admin

# 1. Check HTML input has multiple attribute
grep -n 'name="image_file\[\]"' ordinances.php | wc -l
# Should show: 2 (one for add, one for edit)

# 2. Check PHP handles arrays
grep -n '!empty.*image_file.*name.*0' ordinances.php | wc -l
# Should show: 2

# 3. Check JavaScript functions exist
grep -n 'async function processFilesWithAutoFill' ordinances.php | wc -l
# Should show: 1

grep -n 'async function processFiles' ordinances.php | wc -l
# Should show: 1

# 4. Check syntax
php -l ordinances.php
# Should show: No syntax errors
```

## Testing Instructions

1. **Open the application**
   - Navigate to Ordinances page
   - Click "Add New Ordinance"

2. **Select Multiple Files**
   - Click the file input
   - Hold Ctrl (Windows) or Cmd (Mac)
   - Click on 2-3 image files
   - Verify file counter shows "3 file(s) selected"

3. **Verify Processing**
   - OCR should process each file
   - Progress bar should show
   - Form fields should auto-fill

4. **Submit Form**
   - Fill required fields
   - Click "Add Ordinance"
   - Verify all files uploaded successfully

5. **Check Database**
   - Open database
   - Check `ordinances` table
   - Verify `image_path` column contains pipe-separated URLs:
     `https://minio/file1.jpg|https://minio/file2.jpg|https://minio/file3.jpg`

## Debug Tools

### Debug Script
Created at: `/home/delfin/code/clone/eFIND/admin/test_upload_debug.php`

Usage:
1. Access: http://your-domain/admin/test_upload_debug.php
2. Select multiple files
3. Submit
4. Check $_FILES structure output

### Browser Console Test
Open browser console (F12) and run:
```javascript
// Check multiple attribute
console.log(document.getElementById('image_file').multiple);
// Should show: true

// Check name attribute
console.log(document.getElementById('image_file').name);
// Should show: "image_file[]"

// Check function exists
console.log(typeof processFilesWithAutoFill);
// Should show: "function"
```

## Common Issues & Solutions

### Issue 1: Only first file uploads
**Cause:** PHP not looping through array
**Solution:** Verify PHP uses `foreach` loop and checks `!empty($_FILES['image_file']['name'][0])`

### Issue 2: No files upload at all
**Cause:** Form missing enctype
**Solution:** Verify form has `enctype="multipart/form-data"`

### Issue 3: JavaScript error
**Cause:** Function not defined
**Solution:** Clear browser cache, hard refresh (Ctrl+Shift+R)

### Issue 4: Files selected but form submits without them
**Cause:** Validation error or redirect before upload
**Solution:** Check PHP error log and $_SESSION['error'] messages

## Status

- ✅ HTML forms updated (both add and edit)
- ✅ PHP backend updated (both add and update handlers)
- ✅ JavaScript functions added
- ✅ File counter display added
- ✅ Syntax verified
- ⏳ **Awaiting user testing to confirm it works**

## Notes

- Resolutions and Minutes already use the EXACT same pattern
- All code now matches between the three modules
- The only difference is the table names and object paths (ordinances/ vs resolutions/ vs minutes/)

## If Still Not Working

Please provide:
1. Screenshot of browser console errors
2. Screenshot of Network tab showing POST request
3. Output from test_upload_debug.php
4. Exact steps you're taking
5. What happens vs what you expect

Then we can debug further.
