# User Management Dual Table Integration

## Summary
Updated the User Management section to fetch and display data from **both** `admin_users` and `users` tables using SQL UNION.

## Changes Made

### 1. Database Query Updates (`users.php`)
- **Main Query**: Modified to use UNION ALL combining both tables
  ```sql
  SELECT id, full_name, contact_number, email, username, role, profile_picture, 
         last_login, created_at, updated_at, 'users' as user_type FROM users
  UNION ALL
  SELECT id, full_name, contact_number, email, username, 'admin' as role, 
         profile_picture, last_login, created_at, updated_at, 'admin_users' as user_type 
  FROM admin_users
  ```

- **Count Query**: Updated to count from both tables for accurate pagination
- **Search Parameters**: Duplicated for both parts of UNION when searching

### 2. Display Updates
- Added **"User Type"** column to distinguish between:
  - **Admin User** (from `admin_users` table) - Yellow badge
  - **Regular User** (from `users` table) - Blue badge

### 3. CRUD Operations
- **Fetch User**: Now checks `user_type` parameter to query the correct table
- **Update User**: Routes to correct table based on `user_type`
  - Handles difference in password field names (`password_hash` vs `password`)
  - Excludes `role` field for `admin_users` (doesn't have this column)
- **Delete User**: Uses `user_type` to delete from correct table

### 4. JavaScript Updates
- Edit button now passes `data-user-type` attribute
- Fetch request includes `user_type` parameter
- Hidden field stores `user_type` in edit form
- Delete links include `user_type` parameter

## Key Differences Between Tables
| Feature | admin_users | users |
|---------|-------------|-------|
| Password field | `password_hash` | `password` |
| Has role column | ❌ No | ✅ Yes |
| Role value | Fixed: 'admin' | Variable (admin/staff/etc) |

## Testing Checklist
- ✅ View users from both tables
- ✅ Search across both tables
- ✅ Edit admin_users entries
- ✅ Edit regular users entries
- ✅ Delete from correct table
- ✅ Pagination works correctly

## Files Modified
- `/clone/eFIND/admin/users.php` - Main user management file
