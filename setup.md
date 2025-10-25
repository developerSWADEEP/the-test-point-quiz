---
sidebar_position: 2
---

# Initial Setup

This guide will walk you through setting up Flutter for the Elite Quiz App development.

## Setup

1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. Extract the downloaded zip file in a location of your choice (avoid paths with special characters or spaces)
3. Add Flutter to your PATH environment variable
4. Open a terminal/command prompt and run the following command to verify the installation:

```bash
flutter doctor -v
```

This command checks your environment and displays a report of the status of your Flutter installation:

![Flutter Doctor](/img/app/flutter_doctor.webp)

### Setting Up an IDE

You can use any of the following IDEs for Flutter development:

1. **Android Studio / IntelliJ IDEA** (recommended):

   - Install Android Studio from [developer.android.com](https://developer.android.com/studio)
   - Install the Flutter and Dart plugins from the marketplace

2. **Visual Studio Code**:
   - Install VS Code from [code.visualstudio.com](https://code.visualstudio.com/)
   - Install the Flutter and Dart extensions from the marketplace

### Setting Up Android SDK

1. Open Android Studio
2. Go to SDK Manager (Tools > SDK Manager)
3. Install the latest Android SDK
4. Install Android Emulator or connect a physical device

### Setting Up iOS Development (Mac Only)

1. Install Xcode from the App Store
2. Install the Xcode Command Line Tools
3. Set up an iOS simulator or connect a physical iOS device

## Running the app

After setting up your development environment, without making any changes to the code simply try to run the app.

This is to ensure that first your setup is done correctly, and you are able to run the app, and second that you know that app runs and if there is any issue you run into and not able to run the app, then it is not because of the app code.

1. Open a terminal/command prompt and navigate to the project directory
2. Run the following command to get all dependencies:

```bash
flutter pub get
```

3. Connect a device or start an emulator/simulator
4. Run the project:

```bash
flutter run
```

The app should now be running on your device or emulator/simulator.

## Troubleshooting Flutter Setup

If you encounter any issues during the Flutter setup, try the following:

1. Run `flutter doctor -v` for more detailed information
2. Follow the recommendations provided by the Flutter doctor
3. Make sure your Android SDK and iOS development tools are properly set up
4. Check your PATH environment variable
5. Restart your computer after installation

If you still face issues, please refer to the [Flutter documentation](https://flutter.dev/docs).
