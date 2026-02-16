# Chatbot Connectivity Issue - Investigation & Fix

## Date: February 12, 2026

## Issue Reported
Chatbot displays error: "Sorry, I'm having trouble connecting. Please try again later."

## Investigation Results

### 1. ✅ N8N Webhook Status
- **Webhook URL**: https://n8n-efind.craftmatrix.org/webhook/5eaeb40b-8411-43ce-bee1-c32fc14e04f1
- **Status**: WORKING ✓
- **Test Result**: Successfully responding with 200 OK
- **Sample Response**: AI is connected and querying MySQL tables correctly

### 2. ✅ API File Status
- **Location**: `/admin/api.php`
- **Status**: EXISTS ✓
- **Headers**: Properly configured with CORS
- **Endpoints**: `/chat`, `/health`, `/categories` all configured

### 3. ⚠️ Potential Issues Identified

#### Issue A: Relative Path Problem
- **Problem**: The chatbot widget uses hardcoded path `/admin/api.php/chat`
- **Impact**: May fail if accessed from different page contexts
- **Fix Applied**: Added dynamic path detection based on current URL

#### Issue B: Poor Error Reporting
- **Problem**: Generic error message hides actual issue
- **Impact**: Cannot diagnose real problem from user perspective
- **Fix Applied**: Enhanced error messages with details and console logging

#### Issue C: No Response Validation
- **Problem**: Doesn't check HTTP status before parsing JSON
- **Impact**: May crash on non-200 responses
- **Fix Applied**: Added HTTP status validation

### 4. Logs Analysis
```
File: /admin/logs/chatbot_activity.log
Last entries show: "JSON decode error: Syntax error"
```
This indicates the API received malformed JSON or output before headers.

## Fixes Applied

### Fix 1: Enhanced Error Handling in chatbot_widget.php
```javascript
// Added:
- Dynamic API path detection
- HTTP status checking
- Detailed console logging
- Better error messages
- Response format validation
```

### Fix 2: Created Diagnostic Tool
- **File**: `/admin/test_chatbot_api.php`
- **Purpose**: Test all chatbot components
- **Tests**:
  - File existence
  - Logs directory permissions
  - N8N webhook connectivity
  - API endpoint accessibility
  - Session status

## How to Diagnose

### Step 1: Access Diagnostic Tool
```
http://your-domain/admin/test_chatbot_api.php
```

### Step 2: Check Browser Console
1. Open browser DevTools (F12)
2. Go to Console tab
3. Click chatbot icon
4. Send a test message
5. Look for detailed error logs:
   - "Sending message to: api.php/chat"
   - "Response status: [code]"
   - "Response data: [json]"

### Step 3: Check Network Tab
1. Open DevTools Network tab
2. Send chatbot message
3. Look for `api.php` or `chat` request
4. Check:
   - Request URL (should be `/admin/api.php/chat` or `api.php/chat`)
   - Status Code (should be 200)
   - Response preview (should be valid JSON)
   - Response headers (should include `Content-Type: application/json`)

### Step 4: Review Logs
```bash
tail -50 /path/to/admin/logs/chatbot_activity.log
tail -50 /path/to/admin/logs/chatbot_errors.log
```

## Common Causes & Solutions

### Cause 1: Wrong API Path
**Symptoms**: 404 Not Found error
**Solution**: 
- Verify you're on a page in the `/admin/` directory
- Check the URL in browser network tab
- The updated code now auto-detects the correct path

### Cause 2: Session Not Started
**Symptoms**: PHP warnings about headers
**Solution**: 
- Ensure `session_start()` is called before any output
- Check for whitespace or BOM before `<?php` tags
- Already handled in api.php line 8-10

### Cause 3: Database Connection Failed
**Symptoms**: Internal server error
**Solution**:
- Check `/admin/includes/config.php` credentials
- Verify database is accessible
- Check `$conn` variable is passed to API class

### Cause 4: N8N Workflow Not Active
**Symptoms**: 404 from webhook URL
**Solution**:
- Login to https://n8n-efind.craftmatrix.org
- Ensure workflow is in PRODUCTION mode (not test)
- Check webhook URL matches exactly

### Cause 5: Output Before Headers
**Symptoms**: "Headers already sent" warning
**Solution**:
- Remove any echo/print statements before headers
- Check for whitespace before `<?php`
- Ensure no files output HTML before api.php

## Testing the Fix

### Quick Test:
1. Open any admin page (e.g., ordinances.php)
2. Click the chatbot button (blue circular button bottom-right)
3. Type: "What are the latest ordinances?"
4. Send message
5. Check browser console for detailed logs
6. Verify you get a response (not error message)

### Expected Console Output:
```javascript
Sending message to: api.php/chat
Response status: 200
Response data: { output: "...", timestamp: "...", status: "success" }
```

### Expected Chatbot Response:
Should display actual AI response about ordinances, not error message.

## Next Steps if Still Failing

1. **Run diagnostic tool**: `/admin/test_chatbot_api.php`
2. **Check all 5 tests pass**
3. **Use curl to test API directly**:
```bash
curl -X POST http://localhost/admin/api.php/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"test","sessionId":"test123","userId":"guest","timestamp":"2026-02-12T01:00:00Z"}'
```
4. **Check PHP error logs**:
```bash
tail -100 /var/log/apache2/error.log
# or
tail -100 /var/log/php-fpm/error.log
```

5. **Enable PHP error display** (temporarily, for testing):
```php
// Add to top of api.php
ini_set('display_errors', 1);
error_reporting(E_ALL);
```

## Summary

✅ **N8N Webhook**: Working perfectly
✅ **API Endpoint**: Configured correctly  
✅ **Error Handling**: Enhanced with detailed logging
✅ **Path Detection**: Now dynamic and flexible
⚠️ **Root Cause**: Likely JavaScript fetch failing or path mismatch
🔧 **Fix Status**: Applied, needs testing on live site

## Contact
If issue persists after these fixes, check:
1. Browser console for specific JavaScript errors
2. Network tab for actual request/response
3. Server PHP error logs
4. Run the diagnostic tool

The enhanced error messages will now tell you exactly what's wrong!
