# App URL Update Report

## Files Changed

- `PeriMenoApp/Core/Constants/AppConstants.swift`
- `PRIVACY_POLICY.md`
- `AppStore/README.md`
- `phase-7-app-store-readiness-report.md`
- `app-url-update-report.md`

## Exact URLs Used

- Support URL:
  - `https://github.com/macsonn141-beep/PeriMeno`
- Marketing URL:
  - `https://github.com/macsonn141-beep/PeriMeno`
- Privacy Policy URL:
  - `https://github.com/macsonn141-beep/PeriMeno/blob/main/PRIVACY_POLICY.md`

## Placeholder Cleanup

Searched for:

- `example.com`
- `support@example.com`
- `SUPPORT_EMAIL_PLACEHOLDER`
- `placeholder supportURL`
- `placeholder marketingURL`

Result: no matches remain.

## Notes

- `AppConstants.supportEmail` now points users toward `supportURL` until a monitored support inbox is configured.
- `PRIVACY_POLICY.md` now uses the public GitHub repository as the support contact destination.
- App Store readiness docs now describe the current GitHub URLs instead of example placeholders.

## Build Verification

Build passed with:

```bash
xcodebuild -project PeriMeno.xcodeproj -scheme PeriMeno -destination 'platform=iOS Simulator,name=iPhone 17' build
```
