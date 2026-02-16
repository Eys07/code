# FIX GUIDE: HTTP 500 Error on Delete/Update Buttons

## Executive Summary

The HTTP 500 errors when clicking Delete or Update buttons are likely caused by:
1. **Missing error handling** around MinIO operations
2. **Uncaught exceptions** in database or file operations  
3. **Missing POST/GET validation**
4. **Silent failures** in logging functions

The UPDATE SQL queries themselves are **CORRECT**, but lack proper error handling.

---

## Quick Diagnostic Steps

### Step 1: Run the Diagnostic Tool
```
http://your-domain/test_delete_update.php
```

This will show you:
- ✅ Database connection status
- ✅ Required files existence
- ✅ Table structures
- ✅ MinIO client status
- ❌ Actual errors (if any)

### Step 2: Enable Error Display (Temporarily)

Add at the **very top** of each file (ordinances.php, resolutions.php, minutes_of_meeting.php):

```php
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('log_errors', 1);
```

### Step 3: Try Delete/Update Again

- Click a Delete or Update button
- You should now see the actual error message instead of "HTTP ERROR 500"
- Note the error for troubleshooting

---

## Common Issues and Fixes

### Issue 1: MinIO Connection Timeout

**Symptoms:** Page hangs then shows 500 error  
**Fix:** Add timeout handling

```php
// In ordinances.php, around line 530-562
if (isset($_FILES['image_file']) && !empty($_FILES['image_file']['name'][0])) {
    try {
        $minioClient = new MinioS3Client();
        // ... existing code ...
    } catch (Exception $e) {
        error_log("MinIO Error: " . $e->getMessage());
        $_SESSION['error'] = "File upload service unavailable.";
        header("Location: ordinances.php");
        exit();
    }
}
```

### Issue 2: Logger Function Not Defined

**Symptoms:** "Call to undefined function logDocumentDelete()"  
**Fix:** Ensure logger.php is included BEFORE use

```php
// At top of file, BEFORE any operations
include(__DIR__ . '/includes/logger.php');

// Then wrap logging in checks
if (function_exists('logDocumentDelete')) {
    logDocumentDelete('ordinance', $ordinance['title'], $id);
}
```

### Issue 3: Missing POST Variables

**Symptoms:** "Undefined index" errors  
**Fix:** Validate all inputs

```php
if (isset($_POST['update_ordinance'])) {
    // Add validation
    if (!isset($_POST['ordinance_id'])) {
        $_SESSION['error'] = "Missing ordinance ID";
        header("Location: ordinances.php");
        exit();
    }
    
    $id = intval($_POST['ordinance_id']);
    // ... rest of code ...
}
```

### Issue 4: Database Column Mismatch

**Symptoms:** "Unknown column 'description'"  
**Check:** Does the table have all required columns?

```sql
-- Run in MySQL
DESCRIBE ordinances;
DESCRIBE resolutions;
DESCRIBE minutes_of_meeting;
```

**Fix:** If missing, add the column:
```sql
ALTER TABLE ordinances ADD COLUMN description TEXT AFTER title;
ALTER TABLE resolutions ADD COLUMN description TEXT AFTER title;
-- Note: minutes_of_meeting doesn't need description
```

### Issue 5: Session Not Started

**Symptoms:** "Session not started" warning  
**Fix:** Always start session at top

```php
<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
// ... rest of code ...
```

---

## Complete Fix Implementation

### Option A: Quick Patch (10 minutes)

1. **Copy the error debug patch:**
   ```bash
   cat error_debug_patch.php
   ```

2. **Add to top of each file** (after <?php):
   - ordinances.php
   - resolutions.php
   - minutes_of_meeting.php

3. **Test the buttons** - you'll now see detailed errors

4. **Fix the specific error** shown

### Option B: Comprehensive Fix (30 minutes)

1. **Backup current files:**
   ```bash
   cp clone/eFIND/admin/ordinances.php clone/eFIND/admin/ordinances.php.backup
   cp clone/eFIND/admin/resolutions.php clone/eFIND/admin/resolutions.php.backup
   cp clone/eFIND/admin/minutes_of_meeting.php clone/eFIND/admin/minutes_of_meeting.php.backup
   ```

2. **Replace DELETE handlers** with improved versions from `improved_handlers.php`

3. **Replace UPDATE handlers** with improved versions from `improved_handlers.php`

4. **Test thoroughly**

---

## Specific File Changes Required

### File: `ordinances.php`

#### Change 1: Delete Handler (Line ~416)
**Replace:**
```php
if (isset($_GET['action']) && $_GET['action'] === 'delete' && isset($_GET['id'])) {
    $id = intval($_GET['id']);
    // ... existing code ...
```

**With:** (See `improved_handlers.php` lines 12-90)

#### Change 2: Update Handler (Line ~518)
**Replace:**
```php
if (isset($_POST['update_ordinance'])) {
    $id = intval($_POST['ordinance_id']);
    // ... existing code ...
```

**With:** (See `improved_handlers.php` lines 95-260)

### File: `resolutions.php`

Same changes as ordinances.php, but:
- Change table name from `ordinances` to `resolutions`
- Change field from `ordinance_number` to `resolution_number`
- Change field from `ordinance_date` to `resolution_date`
- Keep the `description` field (it exists in resolutions table)

### File: `minutes_of_meeting.php`

Same changes but:
- Change table name to `minutes_of_meeting`
- Use `session_number` instead of ordinance_number
- Use `meeting_date` instead of ordinance_date
- **REMOVE** the `description` field (doesn't exist in this table)

---

## Testing Checklist

After applying fixes:

- [ ] Test **Delete** on Ordinances
- [ ] Test **Update** on Ordinances  
- [ ] Test **Delete** on Resolutions
- [ ] Test **Update** on Resolutions
- [ ] Test **Delete** on Minutes of Meeting
- [ ] Test **Update** on Minutes of Meeting
- [ ] Test with file upload
- [ ] Test without file upload
- [ ] Check activity logs are created
- [ ] Verify files uploaded to MinIO
- [ ] Test with large files
- [ ] Test with multiple files

---

## Rollback Plan

If something goes wrong:

```bash
# Restore from backup
cp clone/eFIND/admin/ordinances.php.backup clone/eFIND/admin/ordinances.php
cp clone/eFIND/admin/resolutions.php.backup clone/eFIND/admin/resolutions.php
cp clone/eFIND/admin/minutes_of_meeting.php.backup clone/eFIND/admin/minutes_of_meeting.php
```

---

## Support Files Created

1. **test_delete_update.php** - Comprehensive diagnostic tool
2. **error_debug_patch.php** - Error handling patch
3. **improved_handlers.php** - Fixed DELETE/UPDATE handlers
4. **HTTP_500_ERROR_INVESTIGATION.md** - Detailed investigation report
5. **HTTP_500_FIX_GUIDE.md** - This file

---

## Expected Outcome

After fixes:
- ✅ Delete buttons work without errors
- ✅ Update buttons work without errors
- ✅ Helpful error messages if something fails
- ✅ Errors logged for debugging
- ✅ No more HTTP 500 errors
- ✅ Graceful degradation if MinIO fails

---

## Need Help?

If you still see errors after applying fixes:

1. Check `/clone/eFIND/admin/logs/debug_errors.log`
2. Run the diagnostic tool again
3. Look for specific error messages
4. Check MinIO is running: `https://minio-gckgwk48ccskg4ogswwgk88s.craftmatrix.org`
5. Check database connection: `mysql -h 72.60.233.70 -P 9008 -u root -p barangay_poblacion_south`

---

## Next Steps

1. ✅ Run diagnostic tool
2. ✅ Enable error display
3. ✅ Identify specific error
4. ✅ Apply appropriate fix
5. ✅ Test all operations
6. ✅ Disable error display (set to 0)
7. ✅ Monitor logs for issues

**Estimated Fix Time:** 10-30 minutes depending on issue complexity
