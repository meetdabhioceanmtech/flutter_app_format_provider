# flutter_project

A new Flutter project.

## Current Project Requirements Version : Last Update - 16/04/2025 - Add By Meet Dabhi

Flutter Version => 3.27.3
Dart Version => 3.6.1
DevTools => 2.40.2

## Project Setup

- Change App package name use change_app_package_name htis package
  - after change package name remove this package
- Change App name
  - android/app/src/main/AndroidManifest.xml
  - ios/Runner/Info.plist
- Connect Firebase
  - Connect Android and Ios app
  - Firebase Add Crashlytics
  - Other Requirements functionality start in firebase

## Project functionality

- Deep Link
- Notification
- API Format - Done
- Common Widgets - Done
- Image Crop functionality - Done
- Firebase - Done
  - Firebase Command Add
- Firebase Crashlytics - Done
  - Test a debug mode please remove main in kReleaseMode (Line no = 100 || Find project Search (FirebaseCrashlytics.instance.crash())
  - How to check Add On Tap Method in => FirebaseCrashlytics.instance.crash()

## State Management and Project Managemnt

- Provider
- Equatable
- dartz

## Local Storage

- Hive
- Shared Preferences

## UI Management

- Flutter Screenutil ==> flutter_screenutil

## Deep link url :

- link -> Prefix
- s -> Screen params
- s= means ==> Screen Name ==> (sProduct ==> Single Product Screen) | (cProduct ==> Single Combo Screen)
- 'https://bakery.oceanapplications.com/link?s=sProduct&code=${userLoginData?.id}'

## APK Size

- Basic Project Time APK Size : (39.7 MB)

## Platform

- Andorid
- IOS

## Platform Generate Hive Adapters

flutter packages pub run build_runner build --delete-conflicting-outputs

## ENV Change

dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

## PlatformCreate APK

flutter build apk --release --dart-define="VERSION=1"
