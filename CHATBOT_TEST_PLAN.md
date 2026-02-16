# Chatbot Testing Plan - February 15, 2026

## Current Status Summary

### ✅ Fixes Applied (February 12, 2026)
- **Backend (api.php)**: Output buffering, try-catch error handling, enhanced logging
- **Frontend (chatbot_widget.php)**: Dynamic path detection, HTTP status checking, detailed console logging
- **Config (config.php)**: Removed deprecated E_STRICT constant

### ✅ Verified Working
- **N8N Webhook**: Responding with HTTP 200 and AI content
- **PHP to N8N**: Curl communication working
- **Database**: Connected
- **Files**: All present and configured

### ⚠️ Last Test Activity
- **Date**: February 12, 2026 09:55:06
- **Result**: JSON decode error (before fixes were finalized)
- **Status**: No activity logged since fixes completed

## Testing Methods

---

## Method 1: Browser Testing (RECOMMENDED)

### Step 1: Access Admin Page
Open one of these pages in your browser:
```
http://[your-domain]/admin/ordinances.php
http://[your-domain]/admin/resolutions.php
http://[your-domain]/admin/minutes_of_meeting.php
http://[your-domain]/admin/dashboard.php
```

### Step 2: Open Developer Tools
- **Chrome/Edge**: Press `F12` or `Ctrl+Shift+I`
- **Firefox**: Press `F12` or `Ctrl+Shift+K`
- **Mac**: Press `Cmd+Option+I`

### Step 3: Check Console Tab
Before clicking anything, check the Console tab for any errors (red text).

### Step 4: Open Chatbot
1. Look for the **blue circular button** at the bottom-right corner
2. Click it to open the chatbot window
3. The chat window should slide up with a welcome message

### Step 5: Send Test Message
1. In the input field, type: **"What are the latest ordinances?"**
2. Click the send button (paper plane icon) or press Enter
3. Watch the Console tab for these messages:
   ```
   Sending message to: api.php/chat
   Response status: 200
   Response data: {output: "...", ...}
   ```

### Step 6: Verify Response
- ✅ **SUCCESS**: Bot responds with actual content about ordinances
- ❌ **FAILURE**: Bot shows error message or nothing happens

### Step 7: Check Network Tab
1. Switch to the **Network** tab in DevTools
2. Look for a request named `chat` or `api.php`
3. Click on it to see details:
   - **Status**: Should be `200 OK` (green)
   - **Response**: Should be JSON with an "output" field
   - **Preview**: Should show the bot's response

---

## Method 2: Command Line Testing

### Test 1: Health Check
```bash
curl http://[your-domain]/admin/api.php/health
```
**Expected Output**:
```json
{
  "status": "healthy",
  "service": "Barangay AI Chatbot",
  "timestamp": "2026-02-15T14:50:00+00:00"
}
```

### Test 2: Direct Chat Request
```bash
curl -X POST http://[your-domain]/admin/api.php/chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "What are the latest ordinances?",
    "sessionId": "test_session_123",
    "userId": "guest",
    "timestamp": "2026-02-15T14:50:00Z"
  }'
```
**Expected Output**:
```json
{
  "output": "[AI response about ordinances]",
  "timestamp": "2026-02-15T14:50:01+00:00",
  "sources": [],
  "confidence": 0.9,
  "sessionId": "test_session_123",
  "status": "success"
}
```

### Test 3: N8N Direct Test
```bash
curl -X POST https://n8n-efind.craftmatrix.org/webhook/5eaeb40b-8411-43ce-bee1-c32fc14e04f1 \
  -H "Content-Type: application/json" \
  -d '{
    "message": "test",
    "sessionId": "test123",
    "timestamp": "2026-02-15T14:50:00Z"
  }'
```
**Expected**: AI-generated response (we already verified this works)

---

## Method 3: Diagnostic Tool

### Access Diagnostic Page
```
http://[your-domain]/admin/test_chatbot_api.php
```

### Expected Results
All 5 tests should show ✓ (checkmark):
1. ✓ api.php exists
2. ✓ Logs directory writable
3. ✓ N8N webhook HTTP 200
4. ✓ N8N responding with content
5. ✓ Session status

---

## Method 4: Log Monitoring

### While Testing, Monitor Logs

**Terminal 1** - Activity Log:
```bash
tail -f /path/to/clone/eFIND/admin/logs/chatbot_activity.log
```

**Terminal 2** - Error Log:
```bash
tail -f /path/to/clone/eFIND/admin/logs/chatbot_errors.log
```

**Terminal 3** - Debug Log (if exists):
```bash
tail -f /path/to/clone/eFIND/admin/logs/chatbot_debug.log
```

### What to Look For
When you send a message through the browser:
- Activity log should show: "Request received: /chat [POST]"
- Activity log should show: "Chat request - User: ..."
- Activity log should show: "Sending to n8n: ..."
- Activity log should show: "N8N response received successfully"
- NO errors should appear in error log

---

## Troubleshooting Guide

### Issue: Chatbot button not visible
**Causes**:
- Page doesn't include chatbot widget
- CSS not loading
- Z-index conflict

**Fix**:
1. Check if page includes: `<?php include(__DIR__ . '/includes/chatbot_widget.php'); ?>`
2. Look at bottom-right corner of page
3. Try scrolling down
4. Check browser zoom level (should be 100%)

---

### Issue: Button visible but nothing happens when clicked
**Causes**:
- JavaScript error
- Event listener not attached

**Fix**:
1. Open Console (F12)
2. Look for red error messages
3. Check if `toggleChatbot` function exists: Type `toggleChatbot` in console and press Enter
4. Hard refresh: `Ctrl+Shift+R`

---

### Issue: Chat opens but message doesn't send
**Causes**:
- JavaScript error in sendMessage function
- Fetch API blocked

**Fix**:
1. Check Console for errors
2. Check Network tab for failed requests
3. Try different browser
4. Disable browser extensions

---

### Issue: "Sorry, I'm having trouble connecting"
**Causes**:
- API path wrong (404)
- API returning error (500)
- CORS issue

**Fix**:
1. Check Console log: "Sending message to: [path]"
2. Verify path is correct: Should be `api.php/chat` or `/admin/api.php/chat`
3. Check Network tab for actual error
4. Look at Response preview in Network tab

---

### Issue: Network shows 404 Not Found
**Causes**:
- Wrong API path
- .htaccess not configured
- mod_rewrite disabled

**Fix**:
1. Check current page URL in browser
2. If on `/admin/page.php`, API should be `api.php/chat` (relative)
3. If outside `/admin/`, API should be `/admin/api.php/chat` (absolute)
4. Verify api.php file exists: `ls -la /path/to/admin/api.php`

---

### Issue: Network shows 500 Internal Server Error
**Causes**:
- PHP error in api.php
- Database connection failed
- Output before headers

**Fix**:
1. Check Response preview in Network tab for error details
2. Check `/logs/chatbot_errors.log`
3. Check PHP error log: `tail -50 /var/log/php-fpm/error.log`
4. Verify database connection: `php -r "require 'includes/config.php'; echo 'OK';"`

---

### Issue: Response has no "output" field
**Causes**:
- N8N returning unexpected format
- API not parsing response correctly

**Fix**:
1. Check Network tab Response preview
2. Look at actual JSON returned
3. Check if `data.output`, `data.response`, or `data.message` exists
4. Check chatbot_activity.log for "N8N response" entries

---

### Issue: Bot responds but says fallback message
**Causes**:
- N8N workflow not active (in test mode)
- N8N returning error
- Timeout

**Fix**:
1. Login to: https://n8n-efind.craftmatrix.org
2. Ensure workflow is **ACTIVE** (not test mode)
3. Check workflow is published to production
4. Test webhook directly with curl

---

## Success Criteria

### ✅ Test Passed If:
1. Blue chat button visible at bottom-right
2. Clicking button opens chat window with welcome message
3. Typing message and clicking send shows typing indicator
4. Bot responds within 5 seconds
5. Response is relevant to the question
6. Console shows no errors (may show warnings, that's OK)
7. Network tab shows 200 OK status
8. Activity log records the interaction

### ❌ Test Failed If:
1. Button not visible
2. Button doesn't open chat
3. Error message appears in chat
4. Console shows JavaScript errors (red text)
5. Network shows 404 or 500 error
6. Bot doesn't respond after 30 seconds
7. Response is generic fallback message
8. Logs show errors

---

## Quick Test Script

Save this as `test_chatbot.sh` and run it:

```bash
#!/bin/bash

DOMAIN="your-domain.com"  # Change this
BASE_URL="http://$DOMAIN/admin"

echo "=== Chatbot Quick Test ==="
echo ""

# Test 1: Health Check
echo "Test 1: Health Check"
curl -s "$BASE_URL/api.php/health" | python3 -m json.tool
echo ""

# Test 2: Chat Request
echo "Test 2: Chat Request"
curl -s -X POST "$BASE_URL/api.php/chat" \
  -H "Content-Type: application/json" \
  -d '{"message":"test","sessionId":"test123","userId":"guest"}' | python3 -m json.tool
echo ""

# Test 3: Check Recent Logs
echo "Test 3: Recent Activity"
tail -5 /path/to/admin/logs/chatbot_activity.log
echo ""

echo "=== Test Complete ==="
```

---

## After Testing

### If Successful ✅
Document the following:
- ✅ Date/time of successful test
- ✅ Browser used
- ✅ Example question and response
- ✅ Performance (response time)
- ✅ Any warnings in console (if any)

### If Failed ❌
Collect the following:
- ❌ Screenshot of Console tab with errors
- ❌ Screenshot of Network tab showing failed request
- ❌ Copy of error message from chat
- ❌ Recent lines from chatbot_activity.log
- ❌ Recent lines from chatbot_errors.log
- ❌ Browser and version used
- ❌ Steps to reproduce the issue

---

## Summary

**The fixes are IN PLACE** (as of Feb 12, 2026), but need verification through actual testing. Based on my investigation:

- ✅ N8N connection is working
- ✅ Backend code has all fixes applied
- ✅ Frontend code has enhanced error handling
- ⚠️ No confirmed successful test since fixes

**Recommended First Step**: Browser testing (Method 1) with DevTools open.

**Most Likely Outcome**: Should work now, but if there are issues, the enhanced logging will show exactly what's wrong.
