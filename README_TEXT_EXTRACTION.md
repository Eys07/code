# Text Extraction Feature Documentation

## Overview

The file upload system now supports automatic text extraction from PDF, DOCX, and image files using OCR (Optical Character Recognition) via Tesseract.

## Supported File Types

### 1. **PDF Files**
- **Text PDFs**: Direct text extraction using `pdftotext`
- **Scanned PDFs**: OCR extraction using Tesseract + ImageMagick
- **Hybrid PDFs**: Automatically detects and uses best method

### 2. **DOCX Files**
- Direct XML parsing of Word documents
- Extracts all text content from document.xml
- No OCR needed (text is already digital)

### 3. **Image Files**
- JPG, JPEG, PNG, TIFF, BMP, GIF
- OCR text extraction using Tesseract
- Supports multiple languages

## System Requirements

### Required Tools

1. **Tesseract OCR** (for OCR extraction)
   ```bash
   sudo apt-get install tesseract-ocr
   ```

2. **ImageMagick** (for PDF to image conversion)
   ```bash
   sudo apt-get install imagemagick
   ```

3. **Poppler Utils** (for PDF text extraction)
   ```bash
   sudo apt-get install poppler-utils
   ```

4. **PHP ZIP Extension** (for DOCX support)
   ```bash
   sudo apt-get install php-zip
   ```

### Install All Dependencies
```bash
sudo apt-get update
sudo apt-get install -y tesseract-ocr imagemagick poppler-utils php-zip
```

### Optional: Additional Languages for OCR
```bash
# Spanish
sudo apt-get install tesseract-ocr-spa

# French
sudo apt-get install tesseract-ocr-fra

# German
sudo apt-get install tesseract-ocr-deu

# List all available languages
apt-cache search tesseract-ocr-
```

## Files Added

```
TextExtractor.php              - Core text extraction class
upload_extract_demo.html       - Enhanced web interface with extraction UI
README_TEXT_EXTRACTION.md      - This documentation
```

## Usage

### Web Interface

1. Open `upload_extract_demo.html` in a browser
2. Select or drag-drop a PDF, DOCX, or image file
3. Configure options:
   - ✅ Extract text automatically
   - ✅ Use OCR for scanned documents
   - ✅ Force upload (override duplicates)
   - Select OCR language
4. Click "Upload & Extract"
5. View extracted text, statistics, and download options

### API Usage

#### 1. Upload with Automatic Extraction

```bash
# Upload PDF with text extraction
curl -X POST \
  -F "file=@document.pdf" \
  -F "extract_text=1" \
  -F "use_ocr=1" \
  -F "ocr_lang=eng" \
  http://yourserver/upload_handler.php?action=upload

# Upload DOCX
curl -X POST \
  -F "file=@document.docx" \
  -F "extract_text=1" \
  http://yourserver/upload_handler.php?action=upload

# Upload image with OCR
curl -X POST \
  -F "file=@scanned.jpg" \
  -F "extract_text=1" \
  -F "ocr_lang=spa" \
  http://yourserver/upload_handler.php?action=upload
```

**Success Response:**
```json
{
  "success": true,
  "message": "File uploaded successfully.",
  "data": {
    "id": "upload_123",
    "original_name": "document.pdf",
    "stored_name": "document.pdf",
    "file_hash": "abc123...",
    "file_size": 524288,
    "mime_type": "application/pdf",
    "uploaded_by": "192.168.1.1",
    "upload_time": "2026-01-20 05:25:30",
    "timestamp": 1737351930,
    "is_forced": false
  },
  "extraction": {
    "success": true,
    "text": "This is the extracted text content...",
    "method": "pdftotext",
    "char_count": 1523,
    "word_count": 245
  }
}
```

#### 2. Extract Text from Already Uploaded File

```bash
curl -X POST \
  -F "filename=document.pdf" \
  -F "use_ocr=1" \
  -F "ocr_lang=eng" \
  http://yourserver/upload_handler.php?action=extract
```

**Response:**
```json
{
  "success": true,
  "text": "Extracted text content here...",
  "method": "tesseract_ocr",
  "pages_processed": 5,
  "char_count": 3521,
  "word_count": 567,
  "language": "eng"
}
```

#### 3. Check System Capabilities

```bash
curl http://yourserver/upload_handler.php?action=capabilities
```

**Response:**
```json
{
  "success": true,
  "capabilities": {
    "tesseract": true,
    "pdftotext": true,
    "imagemagick": true,
    "zip_extension": true,
    "supported_formats": {
      "pdf": true,
      "docx": true,
      "images": true
    }
  }
}
```

### PHP Integration

```php
<?php
require_once 'TextExtractor.php';

$extractor = new TextExtractor('uploads/');

// Extract from PDF
$result = $extractor->extractText('uploads/document.pdf', [
    'ocr' => true,
    'lang' => 'eng'
]);

if ($result['success']) {
    echo "Method: " . $result['method'] . "\n";
    echo "Text length: " . $result['char_count'] . " characters\n";
    echo "Words: " . $result['word_count'] . "\n";
    echo "\nExtracted text:\n" . $result['text'];
} else {
    echo "Error: " . $result['message'];
}

// Check capabilities
$caps = $extractor->getCapabilities();
if (!$caps['tesseract']) {
    echo "Warning: Tesseract not installed!\n";
}
?>
```

## Extraction Methods

### 1. PDF Text Extraction (`pdftotext`)
- **Best for**: Text-based PDFs (not scanned)
- **Speed**: Very fast
- **Quality**: Perfect for digital text
- **Fallback**: If text is sparse, automatically tries OCR

### 2. PDF OCR Extraction (`tesseract`)
- **Best for**: Scanned PDFs, images embedded in PDFs
- **Speed**: Slower (converts to images first)
- **Quality**: Good (depends on scan quality)
- **Process**: PDF → Images (ImageMagick) → OCR (Tesseract)

### 3. DOCX XML Extraction
- **Best for**: Word documents
- **Speed**: Very fast
- **Quality**: Perfect (digital text)
- **Process**: Unzip → Parse word/document.xml → Extract `<w:t>` nodes

### 4. Image OCR Extraction (`tesseract`)
- **Best for**: Photos of documents, screenshots
- **Speed**: Fast
- **Quality**: Good (depends on image quality)
- **Supported**: JPG, PNG, TIFF, BMP, GIF

## Configuration Options

### Text Extraction Options

```php
$options = [
    'ocr' => true,      // Use OCR for scanned documents
    'lang' => 'eng'     // OCR language (eng, spa, fra, deu, etc.)
];
```

### Available Languages

Common Tesseract language codes:
- `eng` - English
- `spa` - Spanish
- `fra` - French
- `deu` - German
- `ita` - Italian
- `por` - Portuguese
- `chi_sim` - Chinese Simplified
- `chi_tra` - Chinese Traditional
- `jpn` - Japanese
- `rus` - Russian
- `ara` - Arabic

Check installed languages:
```bash
tesseract --list-langs
```

## Error Handling

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `tesseract_not_found` | Tesseract not installed | `sudo apt-get install tesseract-ocr` |
| `imagemagick_not_found` | ImageMagick not installed | `sudo apt-get install imagemagick` |
| `zip_not_available` | PHP ZIP extension missing | `sudo apt-get install php-zip` |
| `unsupported_type` | File type not supported | Use PDF, DOCX, or image files |
| `file_not_found` | File doesn't exist | Check file path |
| `ocr_failed` | OCR processing failed | Check image quality, try different language |

### Graceful Degradation

The system gracefully handles missing tools:

1. **No Tesseract**: Images and scanned PDFs won't extract, but text PDFs and DOCX still work
2. **No ImageMagick**: PDF OCR won't work, but direct PDF text extraction still works
3. **No pdftotext**: Falls back to OCR if Tesseract is available
4. **No ZIP extension**: DOCX extraction unavailable

## Performance

### Speed Benchmarks (approximate)

| File Type | Method | Speed | Notes |
|-----------|--------|-------|-------|
| Text PDF (10 pages) | pdftotext | < 1s | Very fast |
| Scanned PDF (10 pages) | OCR | 15-30s | Depends on resolution |
| DOCX | XML parsing | < 1s | Very fast |
| JPG image | OCR | 2-5s | Depends on size |

### Optimization Tips

1. **PDF Text PDFs**: Use pdftotext (automatic)
2. **Reduce Image Size**: Smaller images process faster
3. **Optimal DPI**: 300 DPI is ideal for OCR
4. **Preprocessing**: Clean images improve OCR accuracy
5. **Batch Processing**: Process multiple files asynchronously

## Security Considerations

1. **Command Injection Prevention**: All shell commands use `escapeshellcmd()` and `escapeshellarg()`
2. **Temporary Files**: Automatically cleaned up after processing
3. **File Type Validation**: MIME type and extension checking
4. **Path Safety**: Uses `basename()` to prevent directory traversal
5. **Resource Limits**: Large PDFs may timeout (adjust PHP settings)

### Recommended PHP Settings

```ini
max_execution_time = 300
memory_limit = 512M
upload_max_filesize = 50M
post_max_size = 50M
```

## Troubleshooting

### Tesseract Not Working

```bash
# Check if installed
which tesseract

# Check version
tesseract --version

# Test manually
tesseract test.png output
cat output.txt
```

### ImageMagick PDF Policy Error

If you get policy errors when converting PDFs:

```bash
# Edit policy file
sudo nano /etc/ImageMagick-6/policy.xml

# Find this line:
# <policy domain="coder" rights="none" pattern="PDF" />

# Change to:
# <policy domain="coder" rights="read|write" pattern="PDF" />

# Save and restart
```

### Empty Text Extraction

**Possible causes:**
1. **Scanned PDF without OCR**: Enable OCR option
2. **Poor image quality**: Improve scan quality
3. **Wrong language**: Specify correct OCR language
4. **Corrupted file**: Try re-uploading

### PHP ZIP Extension Missing

```bash
# Install for Ubuntu/Debian
sudo apt-get install php-zip

# Restart web server
sudo systemctl restart apache2
# or
sudo systemctl restart php-fpm
```

## Testing

### Test Script

```bash
# Test PDF text extraction
curl -F "file=@test.pdf" -F "extract_text=1" \
  http://localhost/upload_handler.php?action=upload

# Test DOCX extraction
curl -F "file=@test.docx" -F "extract_text=1" \
  http://localhost/upload_handler.php?action=upload

# Test image OCR
curl -F "file=@test.jpg" -F "extract_text=1" -F "ocr_lang=eng" \
  http://localhost/upload_handler.php?action=upload

# Check capabilities
curl http://localhost/upload_handler.php?action=capabilities
```

### Manual Testing

1. Create test files:
   - Text PDF with readable content
   - Scanned PDF (or scan a document)
   - DOCX with text
   - Photo of printed text

2. Upload each through web interface
3. Verify text extraction accuracy
4. Test different languages
5. Check error handling with unsupported files

## Examples

### Example 1: Extract Text from Invoice PDF

```php
$extractor = new TextExtractor();
$result = $extractor->extractText('invoices/invoice_2024_001.pdf');

if ($result['success']) {
    // Parse extracted text for invoice data
    preg_match('/Invoice Number:\s*(\d+)/', $result['text'], $matches);
    $invoiceNumber = $matches[1] ?? null;
    
    preg_match('/Total:\s*\$([0-9,]+\.\d{2})/', $result['text'], $matches);
    $total = $matches[1] ?? null;
}
```

### Example 2: Batch Process Multiple Files

```php
$files = glob('uploads/*.pdf');
foreach ($files as $file) {
    $result = $extractor->extractText($file, ['ocr' => true]);
    if ($result['success']) {
        file_put_contents($file . '.txt', $result['text']);
    }
}
```

### Example 3: Multi-Language Document

```php
// Try multiple languages
$languages = ['eng', 'spa', 'fra'];
$bestResult = null;
$maxWords = 0;

foreach ($languages as $lang) {
    $result = $extractor->extractText('document.pdf', ['lang' => $lang]);
    if ($result['success'] && $result['word_count'] > $maxWords) {
        $maxWords = $result['word_count'];
        $bestResult = $result;
    }
}
```

## API Reference

### TextExtractor Class

#### `__construct($uploadDir = 'uploads/')`
Initialize extractor with upload directory.

#### `extractText($filePath, $options = [])`
Extract text from file.

**Parameters:**
- `$filePath` (string): Path to file
- `$options` (array): Options
  - `ocr` (bool): Use OCR for scanned documents (default: true)
  - `lang` (string): OCR language code (default: 'eng')

**Returns:** Array with:
- `success` (bool)
- `text` (string): Extracted text
- `method` (string): Extraction method used
- `char_count` (int): Character count
- `word_count` (int): Word count
- `pages_processed` (int): For multi-page documents
- `language` (string): For OCR extractions

#### `getCapabilities()`
Get system capabilities and available tools.

**Returns:** Array with tool availability and supported formats.

## Support

For issues:
1. Check system capabilities via API
2. Verify dependencies are installed
3. Check PHP error logs
4. Test extraction manually with command-line tools

## License

Part of the File Upload System. Use and modify as needed.

---

**Updated**: January 2026
**Version**: 1.0.0
