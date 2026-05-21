# PeriMeno Project Status

Last updated: 2026-05-19

## Current State

PeriMeno has been scaffolded as a local Xcode SwiftUI iOS project.

- Project name: PeriMeno
- Bundle ID: com.perimeno.app
- Minimum supported iOS: iOS 17.0
- Supported device family: iPhone and iPad
- Xcode project: /Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj
- App target: PeriMeno
- Scheme: PeriMeno
- Architecture: SwiftUI + SwiftData + simple MVVM
- Privacy model: offline-first, local data, no server, no ads, no third-party analytics

## Completed

- Root folder created at /Users/macsonnnnui/Desktop/PeriMeno
- Xcode project created and opened in Xcode
- Full folder and group scaffold created from the master spec
- SwiftUI MVP shell implemented
- SwiftData models scaffolded
- Core app tabs and navigation scaffolded
- Onboarding, Home, Log Entry, Brain Fog, Symptoms, Cycle, Medications, Insights, Appointment Builder, Reports, Paywall, and Settings feature folders created
- Premium manager and StoreKit product ID scaffold created
- Insights, correlation, stage hint, report, PDF, HealthKit, biometric lock, and localization services scaffolded
- Localizable.xcstrings created
- Test and UI test scaffold files created
- Terminal build verified successfully for the PeriMeno target with iphoneos SDK
- Simulator runtime verified with iPhone 17 Pro on iOS 26.5
- Simulator build, install, and launch verified for com.perimeno.app
- Info.plist now includes standard bundle metadata required for simulator installation
- Asset catalogs are included in the resources build phase
- AppIcon and AccentColor are configured for Debug and Release builds
- A complete generated AppIcon PNG set is available in `Assets.xcassets`
- Unit and UI test targets are now part of the Xcode project
- The shared PeriMeno scheme includes `PeriMenoTests` and `PeriMenoUITests`
- Scheme test run verified successfully on iPhone 17 Pro / iOS 26.5 simulator
- Privacy review added for HealthKit and report export flows

## Build Verification

Known successful command:

```sh
xcodebuild -project /Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj -target PeriMeno -configuration Debug -sdk iphoneos CODE_SIGNING_ALLOWED=NO SYMROOT=/tmp/PeriMenoBuildFinal OBJROOT=/tmp/PeriMenoBuildFinal/Intermediates build
```

Result:

```text
BUILD SUCCEEDED
```

Latest successful asset-enabled command:

```sh
xcodebuild -project /Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj -target PeriMeno -configuration Debug -sdk iphoneos CODE_SIGNING_ALLOWED=NO SYMROOT=/tmp/PeriMenoBuildAssets OBJROOT=/tmp/PeriMenoBuildAssets/Intermediates build
```

Result:

```text
BUILD SUCCEEDED
```

Latest successful full test command:

```sh
xcodebuild test -project /Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj -scheme PeriMeno -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5' -derivedDataPath /tmp/PeriMenoDerivedTestRun CODE_SIGNING_ALLOWED=NO
```

Result:

```text
TEST SUCCEEDED
```

Known successful simulator command:

```sh
xcodebuild -project /Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj -scheme PeriMeno -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5' -derivedDataPath /tmp/PeriMenoDerivedSim CODE_SIGNING_ALLOWED=NO build
```

Install and launch:

```sh
xcrun simctl install B9B20A95-9368-49E6-A948-EA0869243DDB /tmp/PeriMenoDerivedSim/Build/Products/Debug-iphonesimulator/PeriMeno.app
xcrun simctl launch B9B20A95-9368-49E6-A948-EA0869243DDB com.perimeno.app
```

## Local Xcode Environment Note

Simulator runtime is now visible to terminal tooling:

```text
iPhone 17 Pro / iOS 26.5
```

The app has been successfully built for the simulator, installed, and launched with bundle ID `com.perimeno.app`.

## Current Bundle ID

The project already has a Bundle ID:

```text
com.perimeno.app
```

Current related settings:

- Product bundle identifier: com.perimeno.app
- Marketing version: 1.0
- Current project version: 1
- Development team: blank
- Code signing style: Automatic

Before TestFlight or device deployment:

- Set a real Apple Developer Team ID.
- Confirm the Bundle ID in Apple Developer/App Store Connect.
- Enable required capabilities intentionally.

## Supported iOS Version

Minimum deployment target:

```text
iOS 17.0
```

Reason:

- SwiftData support starts at iOS 17.
- MVP uses SwiftData local persistence.

## Language Status

Localization catalog:

```text
PeriMenoApp/Resources/Localization/Localizable.xcstrings
```

Locale scaffolds:

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

Status:

- English values are available for scaffolded strings.
- Other locales are scaffolded but require proper human translation before launch.
- New user-facing strings should be added as keys in Localizable.xcstrings.

## Free Feature Boundary

Free feature scope:

- Onboarding
- Local daily logging
- Symptom selection
- Brain fog quick mode
- Cycle logging
- Medication logging scaffold
- Basic home dashboard
- Basic local insights
- Privacy/security settings
- Health access education
- Local-only data storage

Free feature constraints:

- No cloud sync
- No account requirement
- No ads
- No third-party analytics
- No server dependency

## Paid Feature Boundary

Premium product IDs:

```text
com.perimeno.premium.monthly
com.perimeno.premium.yearly
com.perimeno.lifetime
```

Premium feature scope:

- Advanced insights
- Correlation analysis
- Longer trend windows
- Doctor-ready report generation
- PDF export
- Appointment prep builder
- Report templates
- Future HealthKit-powered insight enrichment

Premium constraints:

- Must remain privacy-first.
- Must not introduce ads.
- Must not require a server for MVP.
- Must use StoreKit for real purchases.

## Immediate Next Steps

1. Set Apple Developer Team ID for device builds.
2. Connect StoreKit products in App Store Connect.
3. Complete real translations for non-English locales.
4. Expand MVP views from scaffold to production UI.

## Codex Frontload Reminder

For future terminal-based Codex work, read these first:

```text
MasterSpec.md
PeriMeno_Spec.md
status.md
master-spec.md
README.md
```

Do not frontload `master_spec.md`; it is a legacy underscore duplicate retained for old references.

Then inspect:

```text
PeriMenoApp/App
PeriMenoApp/Core/Models
PeriMenoApp/Features
PeriMenoApp/Services
PeriMenoApp/Resources/Localization/Localizable.xcstrings
```

Default coding rule:

Keep the app local, private, compile-safe, and localization-ready.
