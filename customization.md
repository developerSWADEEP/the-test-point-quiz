---
sidebar_position: 5
---

# App Customization

Customize the Elite Quiz App to match your brand identity and preferences.

## Changing App Logo

You can customize the app logo that appears in the drawer menu and various screens:

1. Navigate to `assets/images/` directory in your project
2. Replace the `app_logo.png` file with your own logo (keep the same filename)
3. Make sure your logo has the appropriate dimensions (recommended: 512x512 pixels)

![Change App Logo](/img/app/change_app_logo.webp)

## Changing Splash Screen & Login Screen Logo

The splash screen is the first screen users see when opening your app:

1. Navigate to `assets/images/` directory in your project
2. Replace the `splash_logo.png` file with your own logo (keep the same filename)
3. This logo is also used on the authentication screens

![Change Splash and Logo](/img/app/change_splash_and_org_logo.webp)

## Changing App Colors

Elite Quiz allows you to easily change the app's color scheme:

1. Open the file `lib/utils/constants.dart`
2. Look for the color constants and update them with your brand colors:

```dart
// Primary Colors
const Color primaryColor = Color(0xffF01876); // Main app color
const Color secondaryColor = Color(0xff3C55D1); // Secondary app color
const Color backgroundColor = Color(0xffffffff); // Background color

// Text Colors
const Color primaryTextColor = Color(0xff212121); // Main text color
const Color secondaryTextColor = Color(0xff757575); // Secondary text color

// Other Colors
const Color pageBackgroundColor = Color(0xfff6f6f6); // Page background color
```

3. Save the file and restart your app to see the changes

![Change Colors](/img/app/change_colors.webp)

## Managing App Languages (Translations)

Elite Quiz supports multiple languages. You can manage them in two ways:

### 1. Adding a New Language via Code

1. Open the `lib/language/languageEn.dart` file
2. Copy this file and rename it according to your language (e.g., `languageFr.dart` for French)
3. Translate all the strings in the new file
4. Open `lib/language/language.dart` and add your new language to the list

### 2. Managing Languages from Admin Panel

You can also manage languages directly from the admin panel:

1. Go to your admin panel
2. Navigate to the System Languages section
3. Add or edit languages as needed

![Add New Language](/img/app/addNewLanguage.webp)

![Add New Language 2](/img/app/addNewLanguage2.webp)

### Language Management in Admin Panel

The admin panel provides an interface to manage both system and quiz languages:

1. System Languages: Used for app interface translations
2. Quiz Languages: Used for quiz content in different languages

![Admin Language 1](/img/app/admin-language-1.webp)

![Admin Language 2](/img/app/admin-language-2.webp)

## Additional Customization Options

### Changing Intro Slider Images

1. Navigate to `assets/images/` directory
2. Replace the `introSlider1.png`, `introSlider2.png`, etc. files with your own images

### Changing Default Profile Images

1. Navigate to `assets/images/` directory
2. Replace the profile image files with your own default profile images

### Changing Fonts

1. Add your custom fonts to the `assets/fonts/` directory
2. Update the `pubspec.yaml` file to include your fonts
3. Update the font family in the theme settings in `main.dart`

## Testing Your Customizations

After making customization changes:

1. Run `flutter clean` to clear the build cache
2. Run `flutter pub get` to ensure all dependencies are updated
3. Restart your app with `flutter run`
4. Test on multiple devices to ensure your customizations look good on different screen sizes

Remember to test your app thoroughly after making visual changes to ensure everything displays correctly on different device sizes and orientations.
