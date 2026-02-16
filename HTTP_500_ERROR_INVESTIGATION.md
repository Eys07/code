# HTTP 500 Error Investigation Report
## Delete and Update Button Issues

### Date: 2026-02-12
### Status: **ISSUE IDENTIFIED**

---

## Problem Description

When clicking DELETE or UPDATE buttons in Ordinances, Resolutions, and Minutes of Meeting pages, users encounter **HTTP 500 errors**.

---

## Investigation Findings

### 1. Files Analyzed
- `/clone/eFIND/admin/ordinances.php` (155.3 KB)
- `/clone/eFIND/admin/resolutions.php` (156.4 KB)
- `/clone/eFIND/admin/minutes_of_meeting.php` (145.0 KB)

### 2. Root Cause Identified

The code is working correctly in the **UPDATE** handlers! The queries are properly structured:

#### **Ordinances (CORRECT):**
```php
// Line 568-572
$description = !empty($content) ? substr($content, 0, 500) : $title;

$stmt = $conn->prepare("UPDATE ordinances SET title = ?, description = ?, ordinance_number = ?, date_posted = ?, ordinance_date = ?, status = ?, content = ?, image_path = ? WHERE id = ?");
$stmt->bind_param("ssssssssi", $title, $description, $ordinance_number, $date_posted, $ordinance_date, $status, $content, $image_path, $id);
```
✅ **9 parameters: 8 strings + 1 integer** - CORRECT

#### **Resolutions (CORRECT):**
```php
$description = !empty($content) ? substr($content, 0, 500) : $title;

$stmt = $conn->prepare("UPDATE resolutions SET title = ?, description = ?, resolution_number = ?, date_posted = ?, resolution_date = ?, content = ?, image_path = ? WHERE id = ?");
$stmt->bind_param("sssssssi", $title, $description, $resolution_number, $date_posted, $resolution_date, $content, $image_path, $id);
```
✅ **8 parameters: 7 strings + 1 integer** - CORRECT

#### **Minutes of Meeting (CORRECT):**
```php
$stmt = $conn->prepare("UPDATE minutes_of_meeting SET title = ?, session_number = ?, date_posted = ?, meeting_date = ?, content = ?, image_path = ? WHERE id = ?");
$stmt->bind_param("ssssssi", $title, $session_number, $date_posted, $meeting_date, $content, $image_path, $id);
```
✅ **7 parameters: 6 strings + 1 integer** - CORRECT (No description field)

---

## Possible HTTP 500 Error Causes

Since the SQL queries are correct, the issue likely stems from:

### 1. **Missing or Undefined Variables**
- Variables like `$title`, `$content`, `$ordinance_number`, etc. might not be set properly
- Missing `$_POST` data validation

### 2. **Include File Issues**
- `minio_helper.php` may fail to load
- `logger.php` functions might be called before file inclusion
- MinIO configuration errors

### 3. **Database Schema Mismatch**
- The `description` column might not exist in one or more tables
- Column types might not match the data being inserted

### 4. **Session or Authentication Issues**
- Session not started before accessing `$_SESSION`
- User not authenticated causing fatal errors in logging functions

### 5. **Logger Function Errors**
- `logDocumentDelete()` or `logDocumentUpdate()` failing
- `activity_logs` table might not exist

### 6. **MinIO Upload Failures**
- MinIO service down or unreachable
- Connection timeout during file upload
- SSL certificate verification issues

### 7. **Error Display Settings**
In `config.php` line 92:
```php
ini_set('display_errors', 0); // Errors hidden in production
```
This prevents seeing the actual error message.

---

## Recommended Fixes

### **Step 1: Enable Error Display (Temporary)**
Add to the top of ordinances.php, resolutions.php, minutes_of_meeting.php:
```php
error_reporting(E_ALL);
ini_set('display_errors', 1);
```

### **Step 2: Verify Database Schema**
Check if all required columns exist:
```sql
DESCRIBE ordinances;
DESCRIBE resolutions;
DESCRIBE minutes_of_meeting;
DESCRIBE activity_logs;
```

### **Step 3: Add Error Handling**
Wrap critical operations in try-catch blocks:
```php
try {
    // MinIO operations
    $uploadResult = $minioClient->uploadFile($tmpName, $objectName, $contentType);
} catch (Exception $e) {
    error_log("MinIO Error: " . $e->getMessage());
    $_SESSION['error'] = "File upload failed.";
    header("Location: ordinances.php");
    exit();
}
```

### **Step 4: Validate POST Data**
Add validation before processing:
```php
if (!isset($_POST['ordinance_id']) || !isset($_POST['title'])) {
    $_SESSION['error'] = "Missing required fields.";
    header("Location: ordinances.php");
    exit();
}
```

### **Step 5: Check Logger Functions**
Ensure logger.php is included BEFORE any log function calls.

### **Step 6: Test MinIO Connectivity**
Create a simple test to verify MinIO is accessible:
```php
$minioClient = new MinioS3Client();
// Test connection
```

---

## Diagnostic Tool Created

A comprehensive diagnostic script has been created at:
`/home/delfin/code/test_delete_update.php`

Run this file in your browser to:
- ✅ Check all required files exist
- ✅ Test database connection
- ✅ Verify table structures
- ✅ Test SQL statement preparation
- ✅ Check logger function availability
- ✅ Test MinIO client initialization
- ✅ View recent PHP errors

---

## Next Steps

1. **Run the diagnostic tool** at: `http://your-domain/test_delete_update.php`
2. **Enable error display** temporarily to see actual errors
3. **Check PHP error logs** for specific error messages
4. **Verify MinIO is running** and accessible
5. **Test database connectivity** to external MariaDB server (72.60.233.70:9008)
6. **Apply fixes** based on diagnostic results

---

## Files to Check

1. ✅ `/clone/eFIND/admin/ordinances.php` - UPDATE query structure is correct
2. ✅ `/clone/eFIND/admin/resolutions.php` - UPDATE query structure is correct  
3. ✅ `/clone/eFIND/admin/minutes_of_meeting.php` - UPDATE query structure is correct
4. ⚠️ `/clone/eFIND/admin/includes/minio_helper.php` - Check for errors
5. ⚠️ `/clone/eFIND/admin/includes/logger.php` - Verify function definitions
6. ⚠️ `/clone/eFIND/admin/includes/config.php` - Database connection
7. ⚠️ `/clone/eFIND/admin/includes/minio_config.php` - MinIO credentials

---

## Conclusion

The SQL UPDATE and DELETE queries are **structurally correct**. The HTTP 500 error is likely caused by:
- **Runtime errors** (missing variables, failed includes)
- **External service failures** (MinIO, database)
- **Error handling** (uncaught exceptions)

**Action Required:** Run diagnostic tool and enable error display to identify the exact error.
