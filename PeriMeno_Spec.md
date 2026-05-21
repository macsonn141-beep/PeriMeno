# PeriMeno Implementation Spec

## Quick Project Facts

- Project name: PeriMeno
- Root folder: /Users/macsonnnnui/Desktop/PeriMeno
- Xcode project path: /Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj
- App target: PeriMeno
- Scheme: PeriMeno
- Bundle ID: com.perimeno.app
- Minimum supported iOS: iOS 17.0
- Supported devices: iPhone and iPad
- Current app version: 1.0
- Build number: 1
- Primary language: Swift
- UI framework: SwiftUI
- Persistence framework: SwiftData
- Architecture style: simple MVVM

## Non-Negotiables

- No server for MVP.
- No ads.
- No third-party analytics.
- Offline-first.
- Privacy-first.
- User-facing strings must be localization-ready.
- Do not skip placeholder files from the master spec.
- Do not overengineer; prefer direct and readable code.

## Folder Map

```text
PeriMeno/
  Docs/
  PeriMeno.xcodeproj/
  PeriMenoApp/
    App/
    Core/
    Features/
    Resources/
    Services/
    Shared/
    SupportingFiles/
  PeriMenoTests/
  PeriMenoUITests/
  README.md
  master-spec.md
  master_spec.md        # legacy duplicate; do not frontload
  MasterSpec.md
  PeriMeno_Spec.md
  status.md
```

## App Entry Points

- PeriMenoApp/App/PeriMenoApp.swift
- PeriMenoApp/App/AppState.swift
- PeriMenoApp/App/AppRouter.swift
- PeriMenoApp/App/RootTabView.swift

The app uses a tab-based SwiftUI shell with local navigation paths.

## SwiftData Models

Models are in:

```text
PeriMenoApp/Core/Models
```

Model list:

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

## Locales

Localization catalog:

```text
PeriMenoApp/Resources/Localization/Localizable.xcstrings
```

Supported language and locale scaffolds:

| Locale | Description |
| --- | --- |
| en | English |
| es | Spanish |
| pt-BR | Portuguese (Brazil) |
| fr | French |
| de | German |
| it | Italian |
| ja | Japanese |
| ko | Korean |
| zh-Hans | Simplified Chinese |
| zh-Hant | Traditional Chinese |
| ar | Arabic |
| hi | Hindi |
| id | Indonesian |
| tr | Turkish |
| th | Thai |

Localization rules:

- SwiftUI views should use localization keys such as `home.greeting`.
- Do not add hard-coded user-facing prose directly in views.
- Add new keys to Localizable.xcstrings when introducing new UI copy.
- Non-English locales currently need a translation pass before launch.

## Free vs Paid Boundary

### Free

Free must provide a useful, private, local tracker:

- Onboarding
- Local daily symptom logging
- Basic Brain Fog quick-entry mode
- Basic symptom picker
- Custom symptom scaffold
- Trigger scaffold
- Cycle logging
- Medication logging scaffold
- Basic dashboard
- Basic local insights summary
- Privacy and security settings
- Health access education and permission scaffold
- Local SwiftData persistence

### Premium

Premium should unlock advanced convenience and interpretation:

- Advanced trend views
- Correlation analysis
- Doctor-ready PDF reports
- Appointment preparation builder
- Report templates
- Advanced Brain Fog templates, shortcuts, and longer-history convenience features
- Long-range history views
- Premium insight snapshots
- Future HealthKit-backed insight enrichment

### Premium Product IDs

```text
com.perimeno.premium.monthly
com.perimeno.premium.yearly
com.perimeno.lifetime
```

StoreKit is scaffolded but product metadata is not connected to App Store Connect yet.

## Privacy and Data Rules

- Treat all app data as sensitive health-adjacent data.
- Keep all user entries local unless a future explicit export/share action is added.
- PDF reports must be generated locally.
- HealthKit access must be optional and permission-gated.
- Biometric lock must be optional.
- No background upload behavior.
- No analytics events to third parties.

## Build Commands

Known-good code compile command:

```sh
xcodebuild -project /Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj -target PeriMeno -configuration Debug -sdk iphoneos CODE_SIGNING_ALLOWED=NO SYMROOT=/tmp/PeriMenoBuildFinal OBJROOT=/tmp/PeriMenoBuildFinal/Intermediates build
```

Project listing command:

```sh
xcodebuild -project /Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj -list
```

Expected project list:

- Target: PeriMeno
- Configurations: Debug, Release
- Scheme: PeriMeno

## Current Local Machine Caveat

Xcode currently shows:

```text
iOS 26.5 Not Installed
```

This means:

- Direct simulator Run is not available until the matching simulator runtime is installed.
- Command-line target build can still verify Swift compile/link.
- Asset catalog build phase is currently disabled to avoid an Xcode actool runtime-thinning failure on this machine.
- Assets.xcassets files remain in the project structure and can be re-enabled after installing a simulator runtime.

## Codex Terminal Frontload

For a fresh Codex terminal session, paste or ask Codex to read:

```text
/Users/macsonnnnui/Desktop/PeriMeno/MasterSpec.md
/Users/macsonnnnui/Desktop/PeriMeno/PeriMeno_Spec.md
/Users/macsonnnnui/Desktop/PeriMeno/status.md
/Users/macsonnnnui/Desktop/PeriMeno/master-spec.md
```

Do not frontload `/Users/macsonnnnui/Desktop/PeriMeno/master_spec.md`; it is a legacy underscore duplicate of `master-spec.md`.

Then ask it to inspect:

```text
/Users/macsonnnnui/Desktop/PeriMeno/PeriMenoApp/App
/Users/macsonnnnui/Desktop/PeriMeno/PeriMenoApp/Core
/Users/macsonnnnui/Desktop/PeriMeno/PeriMenoApp/Features
/Users/macsonnnnui/Desktop/PeriMeno/PeriMenoApp/Services
/Users/macsonnnnui/Desktop/PeriMeno/PeriMenoApp/Resources/Localization/Localizable.xcstrings
```

Codex should frontload these rules before coding:

- Keep MVP compile-safe.
- Keep all data local.
- Keep strings localizable.
- Respect free vs premium boundaries.
- Do not add network, ads, or third-party analytics.
- Build after code changes when feasible.
