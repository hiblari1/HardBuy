# HardBuy

HardBuy is a Material 3 expressive Flutter app that tracks your progress in **MAD** while grinding money for a new PC.

## Included core features

- Progress tracker (`current MAD / goal MAD`) with circular progress percentage.
- Signed input handling:
  - `90` adds 90 MAD.
  - `-90` subtracts 90 MAD.
- "Connect your PayPal" button.
- PC parts list updated to your exact target build:
  - AMD Ryzen 5 5600
  - AMD Radeon RX 6600 8GB
  - 16GB RAM (2x8GB) 3200MHz CL16
  - MSI B550M PRO-VDH
  - 512GB SSD NVMe
  - 550W 80+ Bronze PSU
  - Micro-ATX Case
- Moroccan shop lookup buttons for each part (SetupGame.ma, UltraPC.ma, CasaConfig.ma, Crenova.ma).
- Compatibility status per part.
- Per-part MAD target prices with a "Buy this part now" button that unlocks once your saved money reaches that part's price.
- Peripherals section with recommended keyboard, mouse, and performance-first monitor.
- CI workflow docs kept in this README (release artifacts + conflict guard).
- "Preview full build in 3D" quick action.
- "Buy now" button that intentionally warns and does not auto-checkout for safety.
- Account lock banner to `kinanbourguiba7@gmail.com`.

## Fonts

- Base typography: Google Sans-style text theme.
- Big display/headline/title text: Space Grotesk.

## Run

```bash
flutter pub get
flutter run
```

## Platform targets

Flutter supports Android, Linux, macOS, and Windows from a single codebase. Packaging (including Linux AppImage) can be added during CI/release setup.

## CI workflow for release artifacts

GitHub Actions workflow added at:

- `.github/workflows/build_release_artifacts.yml`

It builds and uploads these artifacts:

- Android APK
- Windows EXE bundle (`.zip`)
- macOS DMG
- Linux AppImage

Trigger it manually with `workflow_dispatch` or by pushing to `main`.

## Merge conflict guard

A second workflow `.github/workflows/conflict_guard.yml` blocks merges if conflict markers
(`<<<<<<<`, `=======`, `>>>>>>>`) are present anywhere in the repository.
