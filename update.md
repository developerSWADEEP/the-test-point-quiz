---
title: How to Update
sidebar_position: 8
---

# How to Update Your App and Admin Panel

Keeping your Elite Quiz app and admin panel up to date ensures you benefit from the latest features, improvements, and security fixes. This guide provides a clear, step-by-step process for updating both the app and the admin panel.

## Prerequisites

- **Backup everything**: Before starting, create full backups of your admin panel code, its database, and your app code. This is your safety net in case anything goes wrong.
- **Read the changelog**: Review the provided changelog for details on what has changed in the new version.

---

## General Update Steps

1. **Backup Everything**
   Create full backups of your admin panel code, its database, and your app code.
2. **Apply Changelogs**
   Use the provided changelogs to update your app code to the latest version.
3. **Enable Maintenance Mode**
   Activate maintenance mode in your admin panel to temporarily disable the app for users during the update.
4. **Execute Update Scripts**
   Run the update scripts located within your admin panel.
5. **Thoroughly Test**  
   Test both your admin panel and app to ensure all functionalities work as expected.
6. **Publish to App Stores**  
   Once everything is working, publish the updated app to the Google Play Store and Apple App Store.
7. **Final Admin Panel Configuration**
   - Enable force update in your admin panel
   - Add the current app versions
   - Disable maintenance mode

:::caution
**Panel downgrades are not supported.** If you update the panel, you must also update the app to maintain compatibility.
:::

---

## Updating the Admin Panel

1. **Find the Update Script**
   - Unzip the new admin panel code zip.
   - Navigate to the 'Update Scripts Folder' inside the unzipped content.
2. **Upload the Update Script**
   - In your admin panel, go to the 'System Update Section'.
   - Upload the specific update script for your version transition (e.g., `1.0.0-to-1.0.1.zip`).

---

## Updating Your App

There are two main methods to update your app. Choose the one that best fits your needs:

### Method 1: Starting from Scratch (Recommended)

This is the easiest and least error-prone method, especially for major updates or if you are less technical.

1. **Prepare the New App Code**  
   Start with the new app code provided.
2. **Re-customize**  
   Re-apply your branding and assets.
3. **Configure**  
   Change the package name, app name, and update your configuration files.
4. **Connect**  
   Reconnect your app with Firebase and your admin panel.
5. **Test and Publish**  
   Test thoroughly, then publish to the app stores.

### Method 2: Using Changelog and 'Changed-files' Folder

This method is suitable for minor updates or when there are many added/modified files but few changes to configuration or branding files.

1. **Using the Changelog**
   - Review the `Changelog.txt` for all modifications, additions, deletions, and renames.
   - For added/modified files: Copy from the new app code and replace in your project.
   - For renamed files: Rename as instructed.
   - For deleted files: Remove as instructed.
2. **Using the 'Changed-files' Folder**
   - Copy all files from the root of the 'Changed-files' folder into your project's root. This will add new files and update existing ones.
   - Manually delete or rename files as specified in the changelog.

:::tip
**Recommendation:** Use Method 1 for major updates or if you want a clean, error-free process. Use Method 2 for minor updates or when you are comfortable manually merging changes.
:::

:::danger
**Caution:** If configuration or branding files are updated in the new version, copying them directly may overwrite your customizations. Always backup and manually re-integrate your changes if needed.
:::

---

## Frequently Asked Questions (FAQ)

**Q: Why should I update my app and admin panel?**  
A: Updates provide new features, performance improvements, bug fixes, and security enhancements.

**Q: Is backup really necessary?**  
A: Absolutely! Backups are your safety net if anything goes wrong during the update.

**Q: What is maintenance mode and why is it needed?**  
A: Maintenance mode temporarily disables your app for users, preventing errors during updates.

**Q: What happens if I only update the admin panel?**  
A: Panel downgrades are not supported. You must also update the app to maintain compatibility.

**Q: Which app update method is recommended?**  
A: Method 1 (Starting from Scratch) is generally recommended for most users.

**Q: Will my customizations be affected by the update?**  
A: Yes, especially if you use Method 2. Always backup and re-integrate your customizations if needed.

**Q: What if I encounter an error during the update?**  
A: Restore from your backup and contact support if needed.

**Q: Do I need to republish my app after every admin panel update?**  
A: If the admin panel update requires an app update for compatibility, then yes, you must republish.
