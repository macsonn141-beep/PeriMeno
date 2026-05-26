# App Privacy Answer Sheet

## Recommended App Privacy Answer

Recommended App Store Connect answer for the current PeriMeno build:

**Data Not Collected**

Based on the current codebase, PeriMeno stores core symptom tracking data locally on the user's device and does not send app data to a developer-controlled server. The app does not include third-party analytics, crash reporting SDKs, ad SDKs, remote logging, account creation, or backend upload behavior.

## Audit Findings

Reviewed code and project files for:

- Third-party analytics SDKs
- Crash reporting SDKs
- Advertising SDKs
- Remote logging
- Backend upload behavior
- Direct network upload code
- Server configuration
- Tracking domains

Findings:

- No Firebase, Crashlytics, Sentry, Amplitude, Mixpanel, AppsFlyer, Adjust, AdMob, Google Mobile Ads, Facebook/Meta SDK, Segment, Datadog, New Relic, or Bugsnag references found.
- No `URLSession` or third-party networking framework usage found.
- No backend upload path found.
- No advertising code found.
- No third-party analytics code found.
- `PrivacyInfo.xcprivacy` declares no tracking and no collected data types.
- `AppConfiguration.plist` declares offline-first behavior, no server, no ads, and no third-party analytics.
- `StoreKit` is used for purchases. Apple handles purchase processing; the current app uses StoreKit state to unlock premium locally.
- `HealthKit` is optional and user-permissioned. Current app code reads optional Health authorization state/data for local app experience and does not upload Health data.
- `os.Logger` is used locally for debug diagnostics. No remote log shipping was found.

## Assumptions Required For This Answer To Remain True

- Symptom entries, notes, history, reports, and settings remain stored locally only.
- No account system, cloud sync, remote backup, or server API is added.
- No analytics, crash reporting, ad network, attribution, or telemetry SDK is added.
- No remote logging or diagnostics upload is added.
- HealthKit data, if accessed, remains local and is not sent to the developer or any third party.
- StoreKit purchase handling remains limited to Apple purchase APIs and local premium unlock state.
- PDF reports are exported only when the user uses native iOS share/export actions.
- The app does not collect contact information, identifiers, usage data, diagnostics, location, or sensitive data for developer use.

## Future Triggers That Require Updating Privacy Answers

Update App Store Connect privacy answers before release if any of the following are added:

- Account registration, login, user profiles, or server-side identity.
- Cloud sync, remote backup, or data restore through developer servers.
- Any API upload of symptoms, notes, reports, HealthKit values, device identifiers, diagnostics, or usage behavior.
- Third-party analytics, crash reporting, ad SDKs, attribution SDKs, A/B testing, or remote configuration.
- Push notification provider data collection.
- Email support inside the app that sends app/user/device data automatically.
- In-app messaging or support chat.
- Any collection of purchase history outside Apple's StoreKit/App Store systems.
- Any tracking across apps or websites.
- Any change to the privacy manifest that declares collected data or accessed APIs.

## App Review Notes Recommendation

For first submission, explain:

- PeriMeno is an offline-first personal tracking app.
- No account is required.
- Core tracking data is stored locally on device.
- HealthKit access is optional and user-initiated.
- Reports are generated locally and shared only through user-selected iOS share/export actions.
- Premium purchase state is handled through Apple StoreKit.
