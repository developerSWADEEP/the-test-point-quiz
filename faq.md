---
sidebar_position: 8
---

# Frequently Asked Questions

Below are some common questions and answers about the Elite Quiz mobile app.

## General Questions

### How do I change the app logo?

To change the app logo, navigate to `assets/images/` in your project and replace the `app_logo.png` and `splash_logo.png` files with your own logos. See the [App Customization](customization) section for more details.

### How do I change the app colors?

Edit the color constants in the `lib/utils/constants.dart` file to match your brand colors. Check the [App Customization](customization) section for more information.

### How do I add a new language?

You can add new languages either through the admin panel or by adding new language files to the project. See the [App Customization](customization) section for detailed instructions.

## Firebase Integration

### Why do I need Firebase?

Firebase is essential for several key features:

- User authentication (Google, Facebook, Phone)
- Real-time battles between users
- Analytics and crash reporting
- Push notifications

### How do I set up Firebase for my app?

Follow the detailed instructions in the [Firebase Integration](firebase) section, which covers creating a Firebase project, adding your app, and configuring authentication methods.

## Monetization

### How do I set up AdMob ads?

Create an AdMob account, generate ad unit IDs, and add them to your app. Enable ads in the admin panel. See the [App Monetization](monetization) section for details.

### How do I set up in-app purchases?

Configure products in Google Play Console and App Store Connect, then ensure the product IDs match in your app's constants. See the [App Monetization](monetization) section for step-by-step instructions.

## Customization

### How do I manage badges in the app?

Badges can be managed from the admin panel:

1. Go to Badges section in the admin panel
2. Add, edit, or remove badges as needed
3. Set the conditions for earning each badge

![Manage Badges](/img/app/manage-badges.webp)

![Manage Badges 1](/img/app/manage-badges-1.webp)

### How do I modify battle messages?

Battle messages can be customized in the app:

1. Open the file `lib/utils/constants.dart`
2. Look for the battle message constants
3. Modify them as needed

![Battle Message 1](/img/app/battle-message-1.webp)

![Battle Message 2](/img/app/battle-message-2.webp)

## Deployment

### How do I generate a signed APK for Android?

Follow these steps:

1. Create a keystore file
2. Add a `key.properties` file to the `android/` directory
3. Run `flutter build apk --release`

See the [App Deployment](deployment) section for detailed instructions.

### How do I submit my app to the App Store?

Prepare your Xcode project, archive your app, and submit it through App Store Connect. See the [App Deployment](deployment) section for a complete guide.

## Troubleshooting

### My app crashes when logging in with Google

Ensure you've added the correct SHA-1 fingerprint to your Firebase project and properly configured the Google Sign-In settings.

### In-app purchases are not working

Check that your product IDs in the app match exactly with those in Google Play Console or App Store Connect. Also, make sure you've completed all the required tax and banking information in the app store dashboards.

### How do I resolve "Failed to load AdMob ads" error?

- Check that your AdMob IDs are correct
- Ensure the AdMob account is properly set up and approved
- Test with test ad IDs during development
- Check if you've added the required permissions in AndroidManifest.xml and Info.plist

### Firebase authentication is not working

- Verify that you've enabled the authentication methods in Firebase console
- Check that you've added the correct configuration files (google-services.json and GoogleService-Info.plist)
- Make sure you've added all required dependencies in pubspec.yaml

### The app runs in debug mode but crashes in release mode

This is often due to code obfuscation or missing ProGuard rules. Make sure you've added the necessary ProGuard exceptions for any libraries you're using.

## Getting Support

If you encounter issues not covered in this documentation, please contact our support team through:

- Email: support@wrteam.in
- Skype: See the [Support](../support) section for Skype contacts
