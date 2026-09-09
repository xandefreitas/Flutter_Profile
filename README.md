# My Profile App

![Profile App Logo](https://play-lh.googleusercontent.com/ZYwoheqiMzXDQ_9yW9ihn8MDYMy6bWINfsFs6sBjLNmqiuuWqPWMIP3zBSjFsHpZ1amC=w240-h480)

## Overview

Welcome to My Profile App! I'm Alexandre Freitas, a mobile software developer, and this app showcases my career path, skills, and the certificates I've acquired throughout my journey. You can download it for both Android and iOS platforms.

- Android: [Download on Google Play](https://play.google.com/store/apps/details?id=com.alexandrefreitas.flutterProfile)
- iOS: [Download on the App Store](https://apps.apple.com/us/app/profile-app/id6444221915)

## About Me

![Alexandre Freitas](https://avatars.githubusercontent.com/u/68479094?v=4)

I'm a passionate mobile software developer based in Gothenburg, Sweden, with three years of experience in mobile app development, specializing in Flutter, Swift, and C#. With a strong commitment to Agile methodologies and a sharp eye for UI/UX design, delivering efficient and user-friendly applications across iOS, Android, and cross-platform environments. My passion for technology and dedication to innovation, combined with my continuous learning mindset, make me a valuable asset for any software development team, and having versatile skill set puts me as a forward-thinking and dynamic developer ready to make a lasting impact in the ever-evolving tech industry.

## Key Features

- **Career Path:** Explore my journey as a mobile software developer, from my early days to my current role.
- **Skills:** Discover the various skills I've mastered throughout my career.
- **Certificates:** View the certificates and qualifications I've earned, demonstrating my commitment to continuous learning and professional development.
- **Depositions:** Write something about me or my app and see what others think as well!

## Screenshots

![Screenshot 1](https://play-lh.googleusercontent.com/Ic-RBU_I3MESxHBXoRbz6N4uZvyWkjwnjSDfF3mICroAg2oBsAUPa79FB7-wv8z9ZYk=w526-h296-rw)
![Screenshot 2](https://play-lh.googleusercontent.com/H9c-xvFHOcFuv0dgizlC6EuwqV1WEwdePt2VaYhQvPw35ktARjuG4OBTp9qhri4rkSY=w526-h296-rw)
![Screenshot 3](https://play-lh.googleusercontent.com/V_BQWQ8zssNcbDxCjLW-BU9fKVWygLo7P8y64oDEW4CRC_2ADqA0wD6ht5o0H-PRoQ4=w526-h296-rw)
![Screenshot 4](https://play-lh.googleusercontent.com/Rqp-9FGJYFiV6Az9zLkhTVCdRspt0FiGe0dCCmvDUUjxFQnkuo3V28xCbgYvfwGZFZM=w526-h296-rw)

## Installation

To get started with My Profile App, simply follow these links to install it on your device:

- Android: [Download on Google Play](https://play.google.com/store/apps/details?id=com.alexandrefreitas.flutterProfile)
- iOS: [Download on the App Store](https://apps.apple.com/us/app/profile-app/id6444221915)

## Getting Started

Once you've installed the app, open it and start exploring my career path, skills, certificates and depositions.

## Running the App Locally

This project keeps its Firebase configuration out of source control, so it needs to be supplied at build/run time:

1. Copy `dart_define.example.json` to `dart_define.json` and fill in your Firebase project's real values.
2. Always pass `--dart-define-from-file=dart_define.json` when running or building, for example:

   ```
   flutter run --release --dart-define-from-file=dart_define.json
   flutter build apk --dart-define-from-file=dart_define.json
   flutter build ios --dart-define-from-file=dart_define.json
   ```

VS Code's Run/Debug configurations (`.vscode/launch.json`) already include this flag, so running from VS Code works out of the box. Forgetting the flag from a terminal or another IDE will make the app fail to start, since Firebase's configuration values resolve empty without it.

## Architecture & State Management

The app is built around the [BLoC](https://bloclibrary.dev/) pattern (`flutter_bloc`), with one bloc per feature domain under `lib/common/bloc/`: profile, skills, certificates, work history, depositions, language, and account. Each bloc follows the same shape — a bloc, an events file, and a states file (e.g. `certificates_bloc.dart`, `certificates_event.dart`, `certificates_state.dart`) — with `Equatable` on both events and states so unrelated changes don't trigger unnecessary widget rebuilds.

A few reasons this held up well for this app specifically:

- **Domain logic decoupled from the widget tree.** Screens never talk to Firebase directly — they dispatch an event (e.g. `CertificatesFetchEvent`) and rebuild off whatever state the bloc emits (`CertificatesFetchingState`, `CertificatesFetchedState`, `CertificatesErrorState`, ...). Fetching, adding, updating, removing, and error handling all live in the bloc, so that logic can be reasoned about and tested without touching any UI.
- **Real-time data without repeating stream plumbing per screen.** Most blocs subscribe to a live Firestore/Realtime Database stream once (via `emit.forEach`), so a change made anywhere — another device, an admin edit — reaches every listening screen automatically, instead of every screen wiring up its own `StreamBuilder`.
- **One shared error-handling pattern instead of one per screen.** Every bloc follows the same try/catch → error-state flow (`bloc_error_handling.dart`), so a network failure or a Firestore permission error always surfaces the same way: an `...ErrorState` carrying the triggering event and a normalized exception.
- **Domain state and ephemeral UI state stay separate.** Data that comes from the backend (the certificate list, the deposition list, ...) flows through the bloc as typed states; state that's purely local to a screen — like the certificates search query, or which card is expanded — stays as a plain `State` field, so the bloc layer isn't cluttered with things that don't need to be shared across widgets.
- **Predictable growth.** Adding a new feature domain means adding one more bloc that follows the exact same event/state/webclient shape as the existing ones, rather than inventing a fresh state-management approach per screen.

## Firebase Cloud Functions

The `functions/` directory holds this project's backend logic, deployed to Cloud Functions for Firebase (2nd gen, Node.js). It currently has two functions:

- **`cleanupAnonymousUsers`** — a scheduled function (Cloud Scheduler trigger) that runs once a month and deletes anonymous Auth accounts (plus their Firestore `users` document) that have been inactive for more than 30 days, keeping the user base clean of one-off app visits.
- **`notifyAdminOnNewDeposition`** — a Realtime Database trigger on `/depositions/{depositionId}` that fires whenever a new deposition is written. It looks up admin accounts in Firestore (`users` where `roleValue == 1`), collects their stored FCM device token(s), and sends them a push notification so the admin finds out about new depositions without having to check the app.

### Deploying

```
cd functions
npm install
firebase deploy --only functions
```

To deploy a single function instead of both:

```
firebase deploy --only functions:notifyAdminOnNewDeposition
```

The first deploy of a new Realtime Database/Eventarc-triggered function can fail with a permission-denied error while Google Cloud finishes propagating IAM roles for the Eventarc service agent — if that happens, wait a few minutes and retry.

## Continuous Integration & Delivery

This project uses GitHub Actions (`.github/workflows/main.yml`) to lint, test, build, and release the app automatically. Pushes to `new_features`, `develop`, or `main` trigger the pipeline, and pull requests targeting `main` run it as a merge gate. What actually happens depends on which of the three branches is driving the run:

- **`new_features`** — branch for building and testing new functionality. Only linting and testing run here; no app builds are produced.
- **`develop`** — branch for debugging and preparing a release for testing. Runs linting and testing, then produces **debug** builds for both platforms.
- **`main`** — release branch. Runs linting and testing, produces **release** builds as a compile-check, then signs, packages, and publishes them.

### Android

| Stage | `new_features` | `develop` | `main` |
|---|---|---|---|
| Lint & Test | ✅ | ✅ | ✅ |
| Build | — | Debug APK | Release App Bundle (unsigned compile check) |
| Release | — | — | Signs a release App Bundle and uploads it to the Play Store's internal track |

### iOS

| Stage | `new_features` | `develop` | `main` |
|---|---|---|---|
| Lint & Test | ✅ | ✅ | ✅ |
| Build | — | Debug build (no codesign) | Release build (no codesign, compile check) |
| Release | — | — | Signs and archives a release IPA and uploads it to TestFlight |

The Android and iOS release stages only run on `main`, and only sign, package, or upload anything if the relevant secrets (keystore/signing certificate, Play Store service account, App Store Connect API key) are configured in the repository — otherwise those steps are skipped without failing the pipeline. Once both platforms' release stages succeed, a final job downloads the signed App Bundle and IPA and publishes them together as a GitHub Release.

## Feedback and Support

If you have any feedback, suggestions, or encounter any issues while using My Profile App, please feel free to reach out to me:

- Email: [alexandre@email.com](mailto:alexandrefreitas.dev@gmail.com)
- LinkedIn: [Connect with me on LinkedIn](https://www.linkedin.com/in/alexandre-freitas-06b456182/)

## Acknowledgments

A special thanks to all the contributors and supporters who have helped make this app a reality.

---

Thank you for downloading and exploring My Profile App. I hope you enjoy learning about my journey as a mobile software developer and the skills and certificates I've acquired along the way.