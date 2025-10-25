---
sidebar_position: 3
---

# App Configuration

After setting up Flutter and running the project, you'll need to customize the Elite Quiz App to match your requirements.

## Changing Package Name

The package name (also known as application ID) uniquely identifies your app on the device and in the Google Play Store. You'll need to change it to your own package name before publishing.

### Using Android Studio or IntelliJ IDEA:

1. Open the project in Android Studio
2. Right-click on the main app package (com.wrteam.elitequiz) in the Project panel
3. Select Refactor > Rename
4. Select "Rename Package" from the options
5. Enter your new package name following the reverse domain name convention (e.g., com.yourcompany.yourappname)
6. Click "Refactor" and confirm any prompts

![Change Package Name](/img/app/changePackageName.webp)

### Alternative Method 1:

1. Open `android/app/build.gradle` file
2. Find the `applicationId` property
3. Change its value to your desired package name:

```gradle
defaultConfig {
    applicationId "com.yourcompany.yourappname"
    // ...
}
```

![Change Package Name 1](/img/app/changePackageName1.webp)

### Alternative Method 2 (Manual Replacement):

1. Open your project in Android Studio or VS Code
2. Use the "Replace in Files" or "Find and Replace" feature
3. Find all occurrences of "com.wrteam.elitequiz" and replace with your package name

![Change Package Name 2](/img/app/changePackageName2.webp)

#### VS Code:

![VS Code Replace Package Name](/img/app/vs_code_replace_pkg_name.webp)

#### Android Studio:

![Android Studio Replace Package Name](/img/app/studio_replace_pkg_name.webp)

## Changing Application Name

The application name is what users will see on their device under the app icon.

1. Open the file `android/app/src/main/AndroidManifest.xml`
2. Find the `android:label` attribute in the application tag
3. Change its value to your desired app name:

```xml
<application
    android:label="Your App Name"
    ...>
```

4. For iOS, open the file `ios/Runner/Info.plist`
5. Find the key `CFBundleName` and change its value:

```xml
<key>CFBundleName</key>
<string>Your App Name</string>
```

![Rename App](/img/app/rename_app.webp)

## Changing App Version

The app version is important for tracking releases and updates.

1. Open the file `pubspec.yaml` at the root of your project
2. Find the `version` property
3. Update it to your desired version:

```yaml
version: 1.0.0+1 # format is version_name+version_code
```

Where:

- The first part (1.0.0) is the user-visible version name
- The second part (1) is the internal version code used by the Play Store (should be incremented for each release)

![Change App Version](/img/app/change_app_version.webp)

## Next Steps

After configuring these basic settings, you'll need to:

1. Integrate Firebase services
2. Connect to your Admin Panel
3. Customize the app appearance
4. Configure ads and in-app purchases
5. Test your app thoroughly
6. Generate a release build

These topics are covered in the following sections of the documentation.
