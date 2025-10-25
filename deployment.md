---
sidebar_position: 7
---

# App Deployment

Once you've customized and tested your Elite Quiz app, the final step is to prepare it for deployment to app stores.

## Generating a Release Version

### Android Release

1. **Create a Keystore File**:

   ```bash
   keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```

2. **Create key.properties File**:

   - Create a file named `key.properties` in the `android/` directory
   - Add the following content (replace with your keystore details):

   ```properties
   storePassword=your_keystore_password
   keyPassword=your_key_password
   keyAlias=key
   storeFile=path_to_your_keystore_file
   ```

   ![Keystore Properties](/img/app/keystore_properties.png)

3. **Configure Gradle for Release**:

   - The `android/app/build.gradle` file is already configured to use the keystore for release builds

4. **Build Release APK**:

   ```bash
   flutter build apk --release
   ```

   Or to build a bundle for Google Play:

   ```bash
   flutter build appbundle --release
   ```

   ![Android Build Mode](/img/app/android_build_mode.png)

### iOS Release

1. **Configure Xcode Project**:

   - Open the `ios/Runner.xcworkspace` file in Xcode
   - Configure signing with your Apple Developer account
   - Set the bundle identifier to match your registered App ID

2. **Set up Archive Configuration**:

   - Select "Generic iOS Device" as the build target
   - Go to Product > Archive

3. **Build IPA File**:
   - After archiving, the Xcode Organizer will open
   - Click "Distribute App" and follow the steps for App Store distribution

## Configuring Force Update

Elite Quiz includes a force update mechanism to ensure users always have the latest version:

1. In your Admin Panel, go to System Settings
2. Find the Force Update section
3. Enable Force Update
4. Set the minimum required versions for Android and iOS

When users have an older version than the specified minimum, they'll see a force update dialog prompting them to update the app.

![Force Update](/img/app/force-update.webp)

![Force Update 2](/img/app/force-update-2.webp)

![Force Update 3](/img/app/force-update-3.webp)

![Force Update 4](/img/app/force-update-4.webp)

## Publishing to App Stores

### Google Play Store

1. Create a developer account at [play.google.com/apps/publish](https://play.google.com/apps/publish)
2. Create a new application
3. Fill in all the required information:
   - App description
   - Graphics (icon, feature graphic, screenshots)
   - Categorization
   - Content rating
   - Pricing & distribution
4. Upload your APK or App Bundle
5. Submit for review

### Apple App Store

1. Create a developer account at [developer.apple.com](https://developer.apple.com)
2. Go to [App Store Connect](https://appstoreconnect.apple.com)
3. Create a new iOS app
4. Fill in all the required information:
   - App description
   - Screenshots
   - Keywords
   - Support URL
   - Marketing URL
   - Privacy Policy URL
5. Upload your build through Xcode or Transporter
6. Submit for review

## Post-Launch Considerations

### App Analytics

Elite Quiz includes Firebase Analytics by default. To access analytics:

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to Analytics

### Updating Your App

When you need to update your app:

1. Make your code changes
2. Increment the version number in `pubspec.yaml`
3. Generate new release builds
4. Upload to the app stores
5. Consider using the force update feature for critical updates

### App Store Optimization

To improve your app's visibility:

1. Use relevant keywords in your app title and description
2. Create high-quality screenshots and videos
3. Encourage users to rate and review your app
4. Respond to user reviews
5. Update your app regularly

## Troubleshooting Deployment Issues

### Common Issues:

1. **Signing Issues**: Ensure your keystore is properly configured for Android and your certificates are valid for iOS.
2. **Missing Permissions**: Check the `AndroidManifest.xml` and `Info.plist` files for all required permissions.
3. **Play Store Rejection**: Common reasons include metadata issues, privacy policy concerns, or functionality problems.
4. **App Store Rejection**: Common reasons include UI guideline violations, crash on review, or metadata issues.

If you encounter any deployment issues, please contact our support team for assistance.
