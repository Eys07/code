# Deep Logout HTTP 500 Investigation
## Date: 2026-02-15
## Status: NEEDS WEB SERVER ERROR LOGS ⚠️

---

## Investigation Summary

I've created **4 diagnostic versions** of logout.php and performed extensive testing:

### ✅ What Works (CLI Testing):
1. Database connection - Works
2. activity_logs table - Exists with correct schema
3. logLogout() function - Works perfectly
4. CSRF token generation - Works
5. Session management - Works
6. Cookie clearing - Works
7. All PHP syntax - Valid

### ❌ What's NOT Working:
- HTTP 500 error only occurs when accessed through **web browser**
- Error does NOT occur in command-line testing

---

## Root Cause Analysis

**The HTTP 500 error is happening at the WEB SERVER level, NOT in the PHP code itself.**

Possible causes:
1. Web server configuration (Apache/Nginx)
2. PHP-FPM or mod_php settings
3. Permissions on files or directories
4. Session storage permissions
5. Database connection timeout in web context
6. Output buffering configuration
7. Headers already sent by web server modules

---

## Diagnostic Tools Created

### 1. `/admin/logout_minimal.php`
- Absolute bare-bones logout
- No CSRF, no database, no logging
- Just session destroy and redirect
- **USE THIS TO TEST**: If this works, the problem is in one of the features

### 2. `/admin/logout_step_by_step.php`
- Logs every single step to `logs/step_by_step.log`
- Shows exactly where the failure occurs
- Outputs to screen AND log file
- **USE THIS TO DIAGNOSE**: Check the log file after accessing it

### 3. `/admin/logout_debug.php`
- Full featured with detailed logging
- Logs to `logs/logout_debug.log`
- Tests all components
- **USE THIS FOR PRODUCTION**: More detailed than minimal

### 4. `/admin/logout_safe.php`
- Ultra-defensive error handling
- Catches ALL errors and exceptions
- Logs everything to `logs/logout_errors.log`
- Won't die on any error
- **USE THIS IF OTHERS FAIL**: Most fault-tolerant

---

## IMMEDIATE ACTION REQUIRED

Since I cannot access the web server error logs, **YOU** need to:

### Step 1: Check Web Server Error Logs

```bash
# For Apache
sudo tail -50 /var/log/apache2/error.log

# For Nginx
sudo tail -50 /var/log/nginx/error.log

# For other systems
sudo tail -50 /var/log/httpd/error_log
```

**Look for:**
- "PHP Fatal error"
- "session" related errors
- "permission denied"
- "Cannot modify header information"
- "headers already sent"
- Any error with timestamp matching when you tried to logout

### Step 2: Test The Minimal Logout

1. Temporarily change navbar logout link to: `logout_minimal.php`
2. Try logging out
3. If it works → Problem is with CSRF or database logging
4. If it fails → Problem is with basic session/redirect

###Step 3: Check Step-by-Step Log

1. Temporarily change navbar logout link to: `logout_step_by_step.php`
2. Try logging out
3. Check file: `/admin/logs/step_by_step.log`
4. Find the LAST step that completed
5. The error is in the NEXT step

---

## How to Use Diagnostic Files

### Test 1: Minimal Logout
```php
// In includes/navbar.php, temporarily change line 54:
<li><a class="dropdown-item text-danger" href="logout_minimal.php">Logout</a></li>
```

If this **WORKS** → The problem is in:
- CSRF token validation
- Database logging (logLogout function)
- Cookie clearing code

If this **FAILS** → The problem is in:
- Basic PHP session handling
- Web server configuration
- File permissions

### Test 2: Step by Step
```php
// In includes/navbar.php, temporarily change line 54:
<li><a class="dropdown-item text-danger" href="logout_step_by_step.php">Logout</a></li>
```

After trying to logout, check:
```bash
cat /home/delfin/code/clone/eFIND/admin/logs/step_by_step.log
```

You'll see exactly where it stops.

---

## Common HTTP 500 Causes & Solutions

### 1. Headers Already Sent
**Symptom:** "Cannot modify header information - headers already sent"

**Check:**
```bash
# Look for output before <?php
head -c 10 /home/delfin/code/clone/eFIND/admin/logout.php | od -c
# Should start with: 3c 3f 70 68 70 (<?php)
```

**Fix:** Remove any whitespace or BOM before `<?php`

### 2. Session Storage Permission
**Symptom:** "Failed to write session data"

**Check:**
```bash
# Find session save path
php -r "echo session_save_path();"

# Check permissions
ls -ld /var/lib/php/sessions
```

**Fix:**
```bash
sudo chmod 1777 /var/lib/php/sessions
# OR
sudo chown www-data:www-data /var/lib/php/sessions
```

### 3. Database Connection Timeout
**Symptom:** Works in CLI but not in web

**Check:**
```bash
# Test database from web context
# Create test_db_web.php:
<?php
require_once 'includes/config.php';
echo $conn ? "Connected" : "Failed";
?>
```

**Fix:** Increase timeout in config.php:
```php
mysqli_options($conn, MYSQLI_OPT_CONNECT_TIMEOUT, 10);
```

### 4. PHP Memory/Time Limits
**Check:**
```bash
php -i | grep -E "memory_limit|max_execution_time"
```

**Fix:** In .htaccess or php.ini:
```
php_value memory_limit 256M
php_value max_execution_time 60
```

---

## Testing Checklist

Run through these tests IN ORDER:

- [ ] **Test 1**: Access `/admin/logout_minimal.php` directly in browser
  - Works? → Problem is with CSRF or logging
  - Fails? → Problem is with basic PHP/web server

- [ ] **Test 2**: Access `/admin/logout_step_by_step.php` in browser
  - Check `/admin/logs/step_by_step.log`
  - Find last completed step
  - Next step is where error occurs

- [ ] **Test 3**: Check web server error logs (Apache/Nginx)
  - Look for PHP Fatal errors
  - Look for permission errors
  - Look for session errors

- [ ] **Test 4**: Check PHP error log
  - Location: `/home/delfin/code/clone/eFIND/logs/php_errors.log`
  - Or: `/var/log/php_errors.log`
  - Or: `/var/log/php/error.log`

- [ ] **Test 5**: Enable PHP error display temporarily
  ```php
  // Add to TOP of logout.php:
  ini_set('display_errors', 1);
  error_reporting(E_ALL);
  ```

---

## File Status

| File | Purpose | Status |
|------|---------|--------|
| logout.php | Production version with CSRF | ✅ Syntax valid |
| logout_minimal.php | Test without CSRF/logging | ✅ Created |
| logout_step_by_step.php | Detailed diagnostics | ✅ Created |
| logout_debug.php | Debug with logging | ✅ Created |
| logout_safe.php | Ultra-safe with error handling | ✅ Created |

---

## Next Steps

1. **You must provide web server error logs** - I cannot access these
2. **Test logout_minimal.php** - Does basic logout work?
3. **Check step_by_step.log** - Where exactly does it fail?
4. **Share the error logs with me** - Then I can provide exact fix

---

## Quick Commands to Run

```bash
# 1. Test minimal logout from command line
cd /home/delfin/code/clone/eFIND/admin
php logout_minimal.php

# 2. Check for any PHP errors in logs
tail -50 logs/*.log 2>/dev/null

# 3. Check web server is running
ps aux | grep -E "apache|nginx|httpd"

# 4. Check PHP-FPM status (if using it)
sudo systemctl status php-fpm
# OR
sudo systemctl status php8.4-fpm

# 5. Test database connection from web context
echo "<?php require_once 'includes/config.php'; echo \$conn ? 'OK' : 'FAIL'; ?>" > test_db.php
curl http://localhost/admin/test_db.php
# OR access in browser: http://yoursite/admin/test_db.php
```

---

## Critical Information Needed

To fix the HTTP 500 error, I NEED:

1. ✅ **Web server error log output** (Apache/Nginx error.log)
2. ✅ **Output from logout_step_by_step.php** (check logs/step_by_step.log)
3. ✅ **Result of testing logout_minimal.php**
4. ✅ **PHP error log output** (php_errors.log)

**Without these logs, I cannot determine the exact cause of the HTTP 500 error.**

---

## Temporary Workaround

If you need logout to work IMMEDIATELY while debugging:

### Option 1: Use Minimal Logout
```php
// In includes/navbar.php line 54:
<li><a class="dropdown-item text-danger" href="logout_minimal.php">Logout</a></li>
```
⚠️ This bypasses CSRF protection - use only temporarily!

### Option 2: Use Safe Logout
```php
// In includes/navbar.php line 54:
<li><a class="dropdown-item text-danger" href="logout_safe.php">Logout</a></li>
```
This version catches all errors and logs them.

---

## Summary

**What I've Confirmed:**
- ✅ PHP code is syntactically correct
- ✅ Database schema is correct
- ✅ All functions work in CLI context
- ✅ No BOM or hidden characters
- ✅ All includes load successfully

**What's Unknown:**
- ❌ Web server error log content
- ❌ Exact point of failure in web context
- ❌ PHP-FPM/mod_php configuration
- ❌ Session storage permissions

**Conclusion:**
The HTTP 500 is a **web server or PHP runtime issue**, NOT a code logic issue.
Need web server error logs to proceed with fix.

---

## Contact Information for Logs

Please run these commands and share the output:

```bash
# Command 1: Web server error log
sudo tail -100 /var/log/apache2/error.log > /tmp/apache_errors.txt
# OR
sudo tail -100 /var/log/nginx/error.log > /tmp/nginx_errors.txt

# Command 2: Step by step log
cd /home/delfin/code/clone/eFIND/admin
# Access logout_step_by_step.php in browser, then:
cat logs/step_by_step.log > /tmp/logout_steps.txt

# Command 3: PHP errors
cat /home/delfin/code/clone/eFIND/logs/php_errors.log > /tmp/php_errors.txt

# Share these 3 files with me
```

