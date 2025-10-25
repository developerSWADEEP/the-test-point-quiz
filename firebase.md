---
sidebar_position: 4
---

# Firebase Integration

Elite Quiz uses Firebase for authentication, real-time database operations, and cloud storage. This guide will walk you through integrating Firebase with your app.

## Creating a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click on "Add project" and follow the prompts to create a new project
3. Enter a project name and accept the Firebase terms
4. Choose whether to enable Google Analytics (recommended)
5. Complete the project setup

![Create Firebase 1](/img/app/createFirebase1.webp)

![Create Firebase 2](/img/app/createFirebase2.webp)

After creating the project, you'll be taken to the Firebase project dashboard:

![Create Firebase 3](/img/app/createFirebase3.webp)

## Adding Your App to Firebase

### Adding Android App

1. In the Firebase console, click on the Android icon to add an Android app
2. Enter your app's package name (the one you configured in the previous section)
3. Enter an app nickname (optional)
4. Enter your app's SHA-1 signing certificate (for Google Sign-In to work properly)
5. Click "Register app"

![Add Android](/img/app/addAndroid.webp)

6. Download the `google-services.json` file
7. Click "Next" and follow the remaining setup instructions

![Add Android 2](/img/app/addAndroid2.webp)

![Add Android 3](/img/app/addAndroid3.webp)

![Add Android 4](/img/app/addAndroid4.webp)

![Add Android 5](/img/app/addAndroid5.webp)

![Add Android 6](/img/app/addAndroid6.webp)

8. Place the `google-services.json` file in the `android/app` directory of your Flutter project

### Adding iOS App

1. In the Firebase console, click on the iOS icon to add an iOS app
2. Enter your app's Bundle ID (found in the `ios/Runner.xcodeproj/project.pbxproj` file)
3. Enter an app nickname (optional)
4. Enter your App Store ID (optional)
5. Click "Register app"

![Add iOS](/img/app/addIos.webp)

6. Download the `GoogleService-Info.plist` file
7. Click "Next" and follow the remaining setup instructions

![Add iOS 2](/img/app/addIos2.webp)

![Add iOS 3](/img/app/addIos3.webp)

![Add iOS 4](/img/app/addIos4.webp)

![Add iOS 5](/img/app/addIos5.webp)

![Add iOS 6](/img/app/addIos6.webp)

8. Place the `GoogleService-Info.plist` file in the `ios/Runner` directory of your Flutter project

## Enabling Firebase Authentication

Elite Quiz supports multiple authentication methods. Here's how to enable them:

1. In the Firebase console, go to Authentication > Sign-in method
2. Enable the authentication methods you want to use:
   - Email/Password
   - Google
   - Facebook
   - Phone
   - Apple (for iOS)

![Add Firebase Auth](/img/app/addFirebaseAuth.webp)

### Configuring Google Sign-In

Google Sign-In is enabled by default when you add Firebase Authentication. Make sure you've added your SHA-1 fingerprint to your Firebase project.

### Configuring Facebook Sign-In

To enable Facebook authentication:

1. Create a Facebook Developer account and app at [developers.facebook.com](https://developers.facebook.com/)
2. Configure your Facebook app for authentication
3. Add the Facebook App ID and App Secret to Firebase Authentication

![Auth 1](/img/app/auth-1.webp)

### Configuring Phone Authentication

To enable Phone authentication:

1. In the Firebase console, go to Authentication > Sign-in method
2. Enable Phone authentication
3. Add your test phone numbers if using in development

![Auth 2](/img/app/auth-2.webp)

## Setting Up Firebase for Battles

Elite Quiz uses Firebase Realtime Database for real-time battle functionality. To set this up:

1. In the Firebase console, go to Realtime Database
2. Click "Create Database"
3. Choose a location (preferably close to your target audience)
4. Start in test mode, then adjust security rules later

## Connecting to Admin Panel

The final step is to connect your app to your Admin Panel:

1. Open the file `lib/core/config/config.dart` in your project
2. Look for the panelUrl constant and update it with your Admin Panel URL:

```dart
/// Add your panel url here
// NOTE: make sure to not add '/' at the end of url
// NOTE: make sure to check if admin panel is http or https
const panelUrl = 'https://your-admin-panel-url.com';
```

## Testing Firebase Integration

After completing all the steps above, restart your app and test the following:

1. User registration and login
2. Social authentication methods (Google, Facebook, etc.)
3. Real-time battle functionality

If any issues occur, check the Firebase console logs and your app logs for detailed error messages.
