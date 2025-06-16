#  Product Listing App

A Flutter app to list and search products using Firebase Firestore. Includes support for light/dark theme toggling, BLoC state management, and app flavoring (`dev` and `release`).

---

##  Features

-  Firebase Firestore integration
-  Dark & light theme toggle (via BLoC)
-  App flavor support (`dev`, `release`)
-  Product search and filters
-  Unit tests with Mockito

---

##  Setup Instructions

### 1.  Prerequisites

- Flutter SDK (3.22.0 or later)
- Firebase CLI configured
- Xcode (for iOS)
- Android Studio (for Android)

### 2.  Install Dependencies

```bash
flutter pub get

flutter pub run build_runner build --delete-conflicting-outputs

