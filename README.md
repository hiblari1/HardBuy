# HardBuy (Android-only)

HardBuy is a lightweight Material 3 Flutter app to track your PC savings in **MAD**.

## What this repo includes

- Android-focused Flutter app (`lib/main.dart`)
- Simple savings tracker with signed input (`90`, `-90`)
- PC parts list with MAD prices and affordability indicator
- Local persistence via `shared_preferences`
- Android APK GitHub Actions workflow

## Run locally

```bash
flutter pub get
flutter run
```

## Android CI build

Workflow file:

- `.github/workflows/build_release_artifacts.yml`

It runs:

1. `flutter create --platforms=android --project-name hardbuy --overwrite .`
2. `flutter pub get`
3. `flutter build apk --release`
4. Uploads `build/app/outputs/flutter-apk/app-release.apk`

Artifact naming is run-scoped to avoid collisions:

- `hardbuy-android-apk-<run_id>-<run_attempt>`

## PR safety

This repo is intended to be updated via PRs.

- `.github/workflows/conflict_guard.yml` blocks PR/push merges if unresolved conflict markers exist.
