---
sidebar_position: 6
---

# App Monetization

Elite Quiz includes multiple monetization options to help you generate revenue from your app.

## Configuring Google AdMob

Elite Quiz supports Google AdMob for displaying advertisements within the app:

### 1. Creating an AdMob Account

1. Go to [AdMob.com](https://admob.google.com/) and sign in with your Google account
2. Create a new app in the AdMob console (or link to your existing app)
3. Get your AdMob App ID for Android and iOS

### 2. Adding Ad Units

1. In the AdMob console, create the following ad units:
   - Banner Ad
   - Interstitial Ad
   - Rewarded Ad
2. Note down the ad unit IDs for each ad type

### 3. Configuring Ad IDs in the App

1. Open the file `lib/utils/constant.dart`
2. Look for the ad-related constants and update them with your AdMob IDs:

```dart
// Android Ad IDs
static const String androidBannerId = "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx";
static const String androidInterstitialId = "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx";
static const String androidRewardedId = "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx";

// iOS Ad IDs
static const String iosBannerId = "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx";
static const String iosInterstitialId = "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx";
static const String iosRewardedId = "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx";
```

![Add Google Ad IDs](/img/app/add-googe-ad-ids.webp)

### 4. Enabling Ads in the App

1. In your Admin Panel, go to System Settings
2. Find the Google Ads section and enable them
3. You can control which ad types are shown (Banner, Interstitial, Rewarded)

![Google Ads 1](/img/app/google-ads-1.webp)

![Google Ads 2](/img/app/google-ads-2.webp)

## Configuring In-App Purchases

Elite Quiz includes a virtual currency (coins) system that can be purchased with real money:

### 1. Setting Up Google Play In-App Products

1. Go to the [Google Play Console](https://play.google.com/console)
2. Select your app and go to "Monetize" > "In-app products"
3. Create in-app products for different coin packages (e.g., "100_coins", "500_coins", etc.)
4. Set the price and description for each product

![In-App Purchase 1](/img/app/in-app-purchase-1.webp)

### 2. Setting Up Apple App Store In-App Purchases

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Select your app and go to "Features" > "In-App Purchases"
3. Create in-app purchases for the same coin packages as Google Play
4. Set the price and description for each product

### 3. Configuring In-App Purchases in the App

1. Make sure the product IDs in the app match the ones you created in the app stores
2. Open the file `lib/utils/constant.dart`
3. Look for the in-app purchase constants and update if needed:

```dart
static const List<String> productIdList = [
  "100_coins",
  "500_coins",
  "1000_coins",
  "2000_coins",
  "5000_coins",
  "10000_coins",
  "remove_ads"
];
```

![In-App Purchase 2](/img/app/in-app-purchase-2.webp)

![In-App Purchase 3](/img/app/in-app-purchase-3.webp)

### 4. Creating "Remove Ads" In-App Purchase

You can also offer a premium feature to remove ads from the app:

1. Create a non-consumable in-app product named "remove_ads" in both app stores
2. Set an appropriate price for this premium feature

![Create Remove Ads IAP](/img/app/create_remove_ads_iap.webp)

### 5. Configuring In-App Purchase in Admin Panel

1. In your Admin Panel, go to System Settings
2. Find the In-App Purchase section and enable it
3. Configure the coin packages and their values

![In-App Settings](/img/app/in_app_settings.webp)

## Earning Module

Elite Quiz also includes an earning module, allowing users to earn coins by:

1. **Daily Login Rewards**: Users get free coins for logging in daily
2. **Watching Rewarded Ads**: Users can watch ads to earn coins
3. **Completing Quizzes**: Users earn coins for completing quizzes
4. **Winning Battles**: Users earn coins when they win battles
5. **Referral System**: Users can refer friends to earn coins

To configure these settings, go to your Admin Panel > System Settings > Earning System.

## Testing Monetization

Before publishing your app:

1. Add test device IDs for AdMob testing
2. Use Google Play's test accounts for testing in-app purchases
3. Use Apple's Sandbox environment for testing iOS in-app purchases

This will allow you to test all monetization features without making real payments.
