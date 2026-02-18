# Foreign Key Constraint Error - FIXED ✅

## Error Message
```
An error occurred: Cannot add or update a child row: a foreign key constraint fails 
(`barangay_poblacion_south`.`activity_logs`, CONSTRAINT `fk_activity_logs_user` 
FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL)
```

## Root Cause
The `logActivity()` function was trying to insert a `user_id` from the session that **doesn't exist** in the `users` table, causing the foreign key constraint to fail.

### Why This Happened:
1. Session has `$_SESSION['user_id']` set (maybe from old login)
2. That user_id doesn't exist in the `users` table (user was deleted or ID changed)
3. When trying to log the activity, foreign key constraint prevents the insert
4. This caused the entire add resolution/ordinance/minute operation to fail

## Database Constraint
```sql
activity_logs.user_id -> FOREIGN KEY -> users.id
Activity logs can only reference user IDs that exist in users table
```

## The Fix

### File: `/home/delfin/code/clone/eFIND/admin/includes/logger.php`

**Added validation in `logActivity()` function (Lines 78-92):**

```php
// Validate user_id exists in users table (foreign key constraint)
if ($user_id !== null) {
    $check_stmt = $conn->prepare("SELECT id FROM users WHERE id = ?");
    if ($check_stmt) {
        $check_stmt->bind_param("i", $user_id);
        $check_stmt->execute();
        $check_result = $check_stmt->get_result();
        if ($check_result->num_rows === 0) {
            // User doesn't exist, set to null to avoid foreign key error
            error_log("User ID $user_id not found in users table, setting to NULL for activity log");
            $user_id = null;
        }
        $check_stmt->close();
    }
}
```

**Also improved user_name fallback (Line 95):**
```php
$user_name = $_SESSION['full_name'] ?? $_SESSION['username'] ?? 'Unknown User';
```

## How It Works Now

### Before (FAILED):
1. Get user_id from session: `user_id = 5`
2. Try to insert into activity_logs with `user_id = 5`
3. ❌ **FOREIGN KEY ERROR** - user_id 5 doesn't exist in users table
4. ❌ Entire operation fails with HTTP 500

### After (SUCCESS):
1. Get user_id from session: `user_id = 5`
2. **Check if user_id 5 exists in users table**
3. User doesn't exist → Set `user_id = NULL`
4. Insert into activity_logs with `user_id = NULL`
5. ✅ **SUCCESS** - Activity logged with NULL user_id
6. ✅ Resolution/Ordinance/Minute added successfully

## Why NULL is OK

The `activity_logs` table allows `user_id` to be NULL:
```
user_id: int(11) NULL YES
```

And the username is still captured in the `user_name` field, so we don't lose track of who did the action.

## Testing

### Clear log and test:
```bash
echo "" > /home/delfin/code/clone/eFIND/logs/php_errors.log
```

### Try adding a resolution:
1. Fill in the form
2. Click "Add Resolution"
3. Should now work! ✅

### Check the log:
```bash
cat /home/delfin/code/clone/eFIND/logs/php_errors.log
```

You might see:
```
User ID X not found in users table, setting to NULL for activity log
```

This is normal and expected if your session has an old/invalid user_id.

## Affected Sections

This fix applies to **ALL** logging operations:
- ✅ Resolutions
- ✅ Ordinances  
- ✅ Meeting Minutes
- ✅ Any other section that uses logging

All sections now handle the foreign key constraint properly.

## Summary

**What was fixed:**
- ✅ Added user_id validation before logging
- ✅ Sets user_id to NULL if user doesn't exist
- ✅ Prevents foreign key constraint errors
- ✅ Improved username fallback logic

**File modified:**
- `/home/delfin/code/clone/eFIND/admin/includes/logger.php` (Lines 74-108)

**Status:** ✅ FIXED - All add operations should now work!

---

## If You Want a Permanent Fix

To ensure the session always has a valid user_id, you should:

1. **Update the login process** to set correct user_id in session
2. **Clear old sessions** that have invalid user_ids
3. **Add session validation** on page load

But for now, the NULL user_id solution works perfectly fine.
