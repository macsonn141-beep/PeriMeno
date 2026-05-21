# PeriMeno Master Spec

## Authority and Frontload Role

Use this file as the first frontload index for future Codex work.

Authority order:

1. `MasterSpec.md` defines the current project identity, local environment caveats, implementation stance, and frontload order.
2. `PeriMeno_Spec.md` defines the current implementation facts and operational rules.
3. `status.md` defines the latest known project state and immediate next steps.
4. `master-spec.md` is the full historical/source product spec for deeper product and scaffold detail.
5. `README.md` is the short human-readable project summary.

Do not use `master_spec.md` for frontload. It is a legacy underscore duplicate retained only so old references do not break.

## Project Identity

- Product name: PeriMeno
- Xcode project: PeriMeno.xcodeproj
- App target: PeriMeno
- Bundle ID: com.perimeno.app
- App category: offline-first perimenopause and menopause symptom tracker
- App architecture: SwiftUI, SwiftData, simple MVVM
- Privacy posture: local-first, no account, no server, no ads, no third-party analytics
- Current app version: 1.0
- Current build number: 1

## Platform Support

- Minimum iOS version: iOS 17.0
- Supported platforms in project settings: iPhoneOS and iPhoneSimulator
- Target device family: iPhone and iPad
- Swift version: Swift 5 project setting, SwiftUI app lifecycle
- Persistence: SwiftData local model container
- Optional Apple frameworks scaffolded: StoreKit, HealthKit, LocalAuthentication, PDFKit

## Bundle ID Ownership

The active Bundle ID is already set in the Xcode project:

```text
com.perimeno.app
```

If this Bundle ID is changed later, update all of these places together:

- PeriMeno.xcodeproj project settings
- PeriMenoApp/SupportingFiles/Info.plist if identifier-specific keys are added
- PeriMenoApp/SupportingFiles/PeriMeno.entitlements if Apple capabilities are added
- StoreKit product setup in App Store Connect
- MasterSpec.md, PeriMeno_Spec.md, and status.md

## Localization

String catalog:

```text
PeriMenoApp/Resources/Localization/Localizable.xcstrings
```

Supported locale scaffold:

- en
- es
- pt-BR
- fr
- de
- it
- ja
- ko
- zh-Hans
- zh-Hant
- ar
- hi
- id
- tr
- th

Current localization status:

- English source values are present.
- Non-English locales are scaffolded so future translation can be filled in without changing code structure.
- User-facing SwiftUI strings should use localization keys, not hard-coded prose.
- New copy must be added to Localizable.xcstrings before shipping.

## Product Principles

- Offline-first: core app value must work without network access.
- Privacy-first: sensitive health and symptom data stays on device by default.
- No server: do not add backend dependencies for MVP.
- No ads: app should not contain ad frameworks or ad placements.
- No third-party analytics: no tracking SDKs, no external analytics events.
- Simple MVVM: Views own presentation, ViewModels own screen state, Services own platform/data logic.
- Clean readable code: prefer semantic names and direct structure over abstract frameworks.

## Free Feature Boundary

Free users should be able to use the app as a meaningful private tracker.

Free features:

- Onboarding and privacy positioning
- Daily symptom logging
- Symptom severity and notes
- Basic Brain Fog quick-entry mode
- Cycle logging
- Medication profile and medication event scaffolds
- Basic home dashboard
- Basic local insight summaries
- Basic settings, privacy, and security screens
- Local SwiftData storage
- Localization-ready interface
- HealthKit permission education screen

Free limitations:

- No cloud sync
- No server backup
- No ads-based unlocks
- No third-party analytics
- Advanced interpretation should stay limited and clearly non-diagnostic

## Paid Feature Boundary

Premium should unlock deeper convenience and preparation features while keeping privacy intact.

Premium products:

- com.perimeno.premium.monthly
- com.perimeno.premium.yearly
- com.perimeno.lifetime

Premium features:

- Advanced insights and longer trend windows
- Correlation exploration between symptoms, triggers, cycle data, sleep, and medication logs
- Doctor-ready PDF report generation
- Appointment preparation builder
- Export/report templates
- Advanced Brain Fog templates, shortcuts, and longer-history convenience features
- Premium badges and paywall flow
- Future HealthKit-backed analysis, if the user grants permission
- Future custom insight summaries

Premium constraints:

- Premium must not introduce ads.
- Premium must not require an account for MVP.
- Premium must not require a server for core tracking.
- Premium must be implemented through StoreKit when moving beyond scaffold state.
- Premium copy must stay localization-ready.

## Data Model Scope

SwiftData model files live in:

```text
PeriMenoApp/Core/Models
```

Current model scaffold:

- UserProfile
- DailyEntry
- SymptomLog
- CustomSymptom
- TriggerLog
- CycleLog
- MedicationProfile
- MedicationEvent
- InsightSnapshot
- AppointmentPrep

Data design principles:

- Use stable identifiers.
- Keep models local and portable.
- Avoid external IDs unless a platform integration requires them.
- Treat health, symptom, medication, and cycle data as sensitive.

## Feature Structure

Feature folders live in:

```text
PeriMenoApp/Features
```

Each feature should prefer:

- Models
- ViewModels
- Views

Current feature areas:

- Onboarding
- Home
- LogEntry
- BrainFogMode
- Symptoms
- Cycle
- Medications
- Insights
- AppointmentBuilder
- Reports
- Paywall
- Settings

## Service Structure

Services live in:

```text
PeriMenoApp/Services
```

Current service areas:

- Persistence
- Insights
- Reports
- Premium
- Health
- Security
- Localization

Service rules:

- Services should be small and focused.
- Services should not introduce network dependencies for MVP.
- Any future external dependency must be justified in docs before implementation.

## Build Notes

Known-good terminal build command used during scaffold verification:

```sh
xcodebuild -project /Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj -target PeriMeno -configuration Debug -sdk iphoneos CODE_SIGNING_ALLOWED=NO SYMROOT=/tmp/PeriMenoBuildFinal OBJROOT=/tmp/PeriMenoBuildFinal/Intermediates build
```

Current local machine note:

- Xcode reports the run destination as "iOS 26.5 Not Installed".
- Target builds work with iphoneos SDK.
- Scheme Run in Xcode requires installing a matching iOS simulator runtime or selecting a physical device.
- Asset catalog files exist in the expected folder structure, but are not currently included in the app build phase because this machine's missing simulator runtime causes actool thinning to fail even for iphoneos target builds.

## Codex Frontload Instructions

When using Codex from terminal, start by reading these files:

1. MasterSpec.md
2. PeriMeno_Spec.md
3. status.md
4. master-spec.md
5. README.md

Do not frontload `master_spec.md`; it is a legacy duplicate of `master-spec.md`.

Then inspect:

- PeriMenoApp/App
- PeriMenoApp/Core/Models
- PeriMenoApp/Services
- PeriMenoApp/Features
- PeriMenoApp/Resources/Localization/Localizable.xcstrings

Do not assume:

- A server exists.
- A simulator runtime is installed.
- StoreKit products are live.
- HealthKit permissions have been granted.
- Non-English translations are production ready.

Default implementation stance:

- Keep changes local.
- Keep privacy explicit.
- Keep user-facing strings localizable.
- Prefer compile-safe scaffold over speculative complexity.
