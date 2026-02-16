# Chatbot HTTP 500 Error - Fix Applied

## Date: February 12, 2026
## Issue: HTTP 500 Internal Server Error

## Problem
Chatbot displays: "Sorry, I'm having trouble connecting. Please check the console for details. Error: HTTP error! status: 500"

## Root Causes Identified

### 1. Output Buffer Issues
**Problem**: Potential output before headers causing HTTP 500
**Fix Applied**: 
- Added `ob_start()` at top of api.php
- Clear all output buffers before sending JSON response
- Wrapped responses with proper buffer cleanup

### 2. E_STRICT Deprecation Warning
**Problem**: PHP 8.1+ deprecated E_STRICT constant causing warnings
**Location**: `/admin/includes/config.php` line 91
**Fix Applied**: Removed `~E_STRICT` from error_reporting

### 3. Poor Error Handling
**Problem**: Exceptions cause 500 errors instead of JSON error responses
**Fix Applied**: Wrapped entire API execution in try-catch with JSON error handling

### 4. Missing Error Visibility
**Problem**: Can't diagnose issues without seeing actual errors
**Fix Applied**: 
- Enhanced console logging in chatbot widget
- Added debug log file for tracking requests
- Better error messages showing actual problem

## Changes Made

### File 1: `/admin/api.php`

```php
// Added at top:
ob_start();  // Buffer all output

// Added debug logging:
$debugLog = __DIR__ . '/logs/chatbot_debug.log';
@file_put_contents($debugLog, date('[Y-m-d H:i:s] ') . "API Called...", FILE_APPEND);

// Enhanced jsonResponse method:
private function jsonResponse($data, $statusCode = 200) {
    // Clear any output buffers
    while (ob_get_level() > 0) {
        ob_end_clean();
    }
    http_response_code($statusCode);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

// Wrapped entire execution:
try {
    $api = new BarangayChatbotAPI($N8N_WEBHOOK_URL, $conn ?? null);
    $api->handleRequest();
} catch (Throwable $e) {
    // Return JSON error instead of 500
    // ...
}
```

### File 2: `/admin/includes/config.php`

```php
// Changed from:
error_reporting(E_ALL & ~E_DEPRECATED & ~E_STRICT);

// To:
error_reporting(E_ALL & ~E_DEPRECATED);
```

### File 3: `/admin/includes/chatbot_widget.php`

```javascript
// Enhanced error handling:
- Dynamic API path detection
- HTTP status code checking before JSON parsing
- Detailed console.log() for debugging
- Error messages include actual error details
```

## Testing Tools Created

### 1. Browser Test Page
**File**: `/admin/test_chatbot_browser.html`
**Purpose**: Test API from browser exactly like the widget does
**Access**: `http://your-domain/admin/test_chatbot_browser.html`

**Features**:
- Test simple API connection
- Send custom messages
- View debug information
- See API path being used

### 2. Command Line Test Script
**File**: `/admin/test_chatbot.sh`
**Purpose**: Test API from command line
**Usage**: `cd /admin && ./test_chatbot.sh`

### 3. Diagnostic Tool
**File**: `/admin/test_chatbot_api.php`
**Purpose**: Full system diagnostic
**Access**: `http://your-domain/admin/test_chatbot_api.php`

## How to Verify the Fix

### Step 1: Clear Browser Cache
```
1. Open Developer Tools (F12)
2. Right-click the reload button
3. Select "Empty Cache and Hard Reload"
```

### Step 2: Test in Browser
```
1. Go to any admin page (e.g., ordinances.php)
2. Open Console (F12 > Console tab)
3. Click the chatbot button (blue circle, bottom-right)
4. Type a message and send
5. Check console logs - should see:
   - "Sending message to: api.php/chat"
   - "Response status: 200"
   - "Response data: { ... }"
```

### Step 3: Use Test Page
```
1. Navigate to: http://your-domain/admin/test_chatbot_browser.html
2. Click "Test API Call"
3. Should see "SUCCESS!" with JSON response
4. If error, check Network tab for details
```

### Step 4: Check Debug Logs
```bash
# View recent API calls
tail -20 /path/to/admin/logs/chatbot_debug.log

# View activity log
tail -20 /path/to/admin/logs/chatbot_activity.log

# View errors
tail -20 /path/to/admin/logs/chatbot_errors.log
```

## Common Issues & Solutions

### Still Getting 500 Error

**Cause A: Apache/Nginx Error**
```bash
# Check web server error log
tail -50 /var/log/apache2/error.log
# or
tail -50 /var/log/nginx/error.log
```

**Cause B: PHP Fatal Error**
```bash
# Check PHP error log
tail -50 /var/log/php-fpm/error.log
# or
tail -50 /path/to/admin/logs/chatbot_errors.log
```

**Cause C: File Permissions**
```bash
# Check if logs directory is writable
ls -la /path/to/admin/logs
# Fix if needed:
chmod 755 /path/to/admin/logs
chmod 644 /path/to/admin/logs/*.log
```

**Cause D: Database Connection**
```bash
# Test database connection
cd /path/to/admin
php -r "include 'includes/config.php'; echo 'DB OK';"
```

### Getting CORS Error

If you see: "CORS policy: No 'Access-Control-Allow-Origin' header"

**Fix**: Already added in api.php:
```php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
```

### Network Tab Shows "Failed" or "Canceled"

**Possible Causes**:
1. Page refreshed before request completed
2. JavaScript error prevented request
3. Browser extension blocked request

**Check**:
1. Browser Console for JavaScript errors
2. Disable browser extensions temporarily
3. Try in Incognito/Private mode

## Expected Behavior After Fix

### ✅ Successful Request:
```
Console Output:
> Sending message to: api.php/chat
> Response status: 200
> Response data: { output: "...", status: "success", ... }

Chatbot Display:
> [Shows AI response text]
```

### ❌ If Still Failing:
```
Console Output:
> Sending message to: api.php/chat
> Response status: 500
> Response data: { output: "...", error: "[specific error]", ... }

Chatbot Display:
> [Shows error with details]
```

## Files Modified

1. ✅ `/admin/api.php` - Enhanced error handling, output buffering
2. ✅ `/admin/includes/config.php` - Fixed E_STRICT deprecation
3. ✅ `/admin/includes/chatbot_widget.php` - Better error visibility

## Files Created

1. 📄 `/admin/test_chatbot_browser.html` - Browser testing tool
2. 📄 `/admin/test_chatbot.sh` - Command line testing tool
3. 📄 `/admin/test_chatbot_api.php` - Diagnostic tool
4. 📄 `/admin/logs/chatbot_debug.log` - New debug log (auto-created)

## Next Steps

1. **Test the chatbot** on a live admin page
2. **Check console logs** for detailed error information
3. **Use test page** if still having issues
4. **Review debug logs** to see exact request flow

## Support Checklist

If issue persists, collect this information:

- [ ] Browser console screenshot showing error
- [ ] Network tab screenshot showing request/response
- [ ] Content of `logs/chatbot_debug.log`
- [ ] Content of `logs/chatbot_errors.log`
- [ ] Result from test page (`test_chatbot_browser.html`)
- [ ] PHP version: `php -v`
- [ ] Web server: Apache or Nginx version

## Summary

The HTTP 500 error was caused by:
1. Lack of output buffering
2. PHP deprecation warnings
3. Poor exception handling

All issues have been fixed with:
- ✅ Output buffering
- ✅ Proper error handling
- ✅ Enhanced debugging tools
- ✅ Better error messages

The chatbot should now work correctly, or at minimum provide clear error messages for troubleshooting.
