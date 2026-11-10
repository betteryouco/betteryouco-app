# BetterYou Co: Mobile App

Flutter app for BetterYou Co, a mental wellness platform. Clients take clinically validated screenings, track their health and work with qualified specialists. Specialists manage clients, programs and messages from the same app.

## Features

- Guest access: GAD-7 and PHQ-8 screenings and a BMI calculator, no account needed
- Client: DASS-21, blood pressure, heart rate, BMI and sleep tracking, wellness score, assessment history
- Specialist directory, program purchase (test-mode payment) and "My Program" progress
- Messaging with session booking requests, reviews
- Specialist side: client list, notes, tasks, assignment requests, earnings
- Email OTP signup with resend, password reset, Google Sign-In (backend support pending)

## Stack

Flutter 3.44 (Dart), Provider for state, Dio for networking, flutter_secure_storage for sessions, flutter_screenutil for sizing.

## Project details

| | |
|---|---|
| Android package | `life.betteryou_co` |
| API base URL | set in `lib/core/network/api_client.dart` |
| Backend | the `betteryouco-web` Laravel project |

## Getting started

```bash
flutter pub get
flutter run
```

To use a local backend, change `baseUrl` in `lib/core/network/api_client.dart`.

## Release build (Android)

1. Create an upload keystore and keep it outside version control:
   `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
2. Create `android/key.properties` with `storePassword`, `keyPassword`, `keyAlias` and `storeFile`.
3. Raise the number after `+` in the `version` line of `pubspec.yaml` for every upload.
4. Build with `flutter build appbundle --release`. The output is `build/app/outputs/bundle/release/app-release.aab`.

Keep `key.properties` and the `.jks` file private and backed up. Without them you cannot publish updates.
