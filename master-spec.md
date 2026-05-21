# Master Spec — Perimenopause / Menopause Tracker iOS App

Canonical full product/source spec. Use `MasterSpec.md` as the frontload index first; use this file when deeper product or scaffold detail is needed. Do not frontload `master_spec.md`; it is a legacy underscore duplicate.

## 0. Document Purpose
This is the single source of truth for building the MVP of a global iOS app for perimenopause / menopause symptom tracking.

This spec is written for Codex with Computer Use enabled so Codex can:
1. Create the project folder structure on the Mac
2. Create a new Xcode project
3. Add the correct groups / folders / files
4. Implement the first working MVP architecture

This app must be:
- iOS only for V1
- SwiftUI first
- No server
- No ads
- Offline-first
- Privacy-first
- Subscription + lifetime purchase capable
- Built for global business
- Ready for 15 languages

---

# 1. Product Overview

## 1.1 Working Product Name
**PeriMeno**

Codename only. Final marketing name can change later.

## 1.2 Product Summary
A private perimenopause and menopause tracker that helps women log symptoms in seconds, understand patterns, and walk into appointments prepared — even on brain fog days.

## 1.3 Core Value Proposition
This is not just another symptom tracker.
It is specifically designed for women who are dealing with:
- brain fog
- fatigue
- emotional swings
- poor sleep
- irregular cycles
- difficulty explaining symptoms to a doctor

The app solves 4 major jobs:
1. Log symptoms quickly
2. Make patterns visible
3. Prepare clear doctor-ready reports
4. Reduce overwhelm on bad days via Brain Fog Mode

---

# 2. Business Model

## 2.1 Pricing Model
Use StoreKit 2.

Products:
- Monthly Subscription: **$6.99 / month**
- Yearly Subscription: **$49.99 / year**
- Lifetime Unlock: **$99.99 one-time**

## 2.2 Free Tier
Free users can:
- log daily symptoms
- log cycle changes
- log medications / supplements
- use basic Brain Fog quick-entry mode
- view last 7 days only
- see basic trends preview
- export only limited preview report

## 2.3 Paid Tier
Paid users unlock:
- unlimited history
- unlimited custom symptoms
- Brain Fog Mode advanced quick logging, templates, shortcuts, and longer-history convenience features
- advanced insights
- correlations
- doctor report export
- appointment builder
- HealthKit integrations
- partner / family explain page
- all premium templates

---

# 3. Target User

## 3.1 Core User
Women roughly 35–55 who are in perimenopause, menopause transition, or early post-menopause.

## 3.2 Main Problems
- Too many symptoms to track mentally
- Symptoms feel random and confusing
- Existing period apps no longer fit
- Brain fog makes tracking difficult
- Doctor appointments are short and hard to prepare for
- Wants privacy and no account creation

---

# 4. Product Principles

## 4.1 Must-Haves
- Zero backend
- No account
- Local-first data storage
- Simple UX
- Fast logging
- Strong privacy language
- Global-ready localization architecture

## 4.2 UX Tone
The app should feel:
- calm
- clean
- non-clinical but credible
- supportive
- not childish
- not “woo-woo”
- not overly medical

---

# 5. Tech Stack

## 5.1 Platform
- iOS 17+
- Swift 5.10+
- SwiftUI
- SwiftData preferred for local persistence
- StoreKit 2
- PDFKit
- Charts
- HealthKit (optional but scaffold now)
- LocalAuthentication for optional Face ID lock

## 5.2 Architecture
Use simple modular MVVM.

Recommended high-level pattern:
- App layer
- Core layer
- Feature layer
- Shared UI layer
- Services layer
- Resources layer

## 5.3 Dependency Rule
- Feature modules can depend on Core and Shared
- Shared can depend on Core
- Services can depend on Core
- App target composes everything
- No circular dependencies

---

# 6. Localization Strategy

Prepare architecture for these 15 languages:
- English
- Spanish
- Portuguese (Brazil)
- French
- German
- Italian
- Japanese
- Korean
- Chinese Simplified
- Chinese Traditional
- Arabic
- Hindi
- Indonesian
- Turkish
- Thai

For MVP implementation now:
- fully implement English strings
- create Localizable scaffolding for all languages
- create placeholder `.xcstrings` entries ready for later translation

Use:
- `Localizable.xcstrings`
- No hardcoded user-facing text in views

---

# 7. MVP Scope

## 7.1 MVP Screens
Build these screens in V1:
1. Onboarding
2. Paywall
3. Home
4. Daily Check-In (Standard)
5. Brain Fog Mode
6. Symptoms Picker
7. Cycle Log
8. Medication / Supplement Log
9. Insights Overview
10. Trend Detail
11. Correlation Detail
12. Appointment Builder
13. Reports Export
14. Settings
15. Privacy / Security
16. Health Access

## 7.2 MVP Functional Areas
- onboarding
- premium access scaffold
- symptom logging
- cycle logging
- medication logging
- custom symptoms
- basic trend charts
- basic correlations
- report export scaffold
- local persistence
- settings
- localization scaffolding

---

# 8. Core Domain Model

Use these SwiftData models.

## 8.1 UserProfile
Fields:
- id: UUID
- createdAt: Date
- preferredLanguageCode: String
- onboardingCompleted: Bool
- isPremiumUnlocked: Bool
- faceIDEnabled: Bool
- selectedTheme: String
- timeZoneIdentifier: String
- ageRange: String?
- menopauseStageHint: String?

## 8.2 DailyEntry
Fields:
- id: UUID
- date: Date
- overallScore: Int
- moodScore: Int
- energyScore: Int
- sleepScore: Int
- brainFogScore: Int
- notes: String
- impactWork: Int
- impactSleep: Int
- impactRelationship: Int
- impactIntimacy: Int
- usedBrainFogMode: Bool
- createdAt: Date
- updatedAt: Date

Relations:
- symptoms: [SymptomLog]
- triggers: [TriggerLog]
- medicationsTaken: [MedicationEvent]
- cycleLog: CycleLog?

## 8.3 SymptomLog
Fields:
- id: UUID
- symptomType: String
- severity: Int
- durationMinutes: Int?
- timeOfDay: String?
- note: String
- isCustom: Bool

## 8.4 CustomSymptom
Fields:
- id: UUID
- name: String
- category: String
- iconName: String
- createdAt: Date
- isArchived: Bool

## 8.5 TriggerLog
Fields:
- id: UUID
- triggerType: String
- intensity: Int?
- note: String

Possible trigger types:
- alcohol
- caffeine
- spicy_food
- sugar
- stress
- poor_sleep
- exercise
- heat
- travel
- illness

## 8.6 CycleLog
Fields:
- id: UUID
- date: Date
- bleedingType: String
- flowLevel: Int
- crampLevel: Int
- note: String

Possible bleedingType:
- none
- spotting
- light
- moderate
- heavy

## 8.7 MedicationProfile
Fields:
- id: UUID
- name: String
- category: String
- dose: String
- frequency: String
- startDate: Date?
- endDate: Date?
- note: String
- isActive: Bool

Categories:
- HRT
- supplement
- prescription
- OTC
- other

## 8.8 MedicationEvent
Fields:
- id: UUID
- medicationProfileID: UUID
- takenAt: Date
- adherence: Bool
- perceivedEffectScore: Int?
- sideEffectNote: String

## 8.9 InsightSnapshot
Fields:
- id: UUID
- generatedAt: Date
- summaryType: String
- title: String
- body: String
- score: Double?

## 8.10 AppointmentPrep
Fields:
- id: UUID
- createdAt: Date
- dateRange: String
- topSymptomsSummary: String
- medicationSummary: String
- suggestedQuestions: [String]
- reportFileURL: String?

---

# 9. Symptom Taxonomy

Seed these default symptoms for MVP:
- hot_flashes
- night_sweats
- poor_sleep
- insomnia
- fatigue
- low_energy
- anxiety
- irritability
- low_mood
- mood_swings
- brain_fog
- forgetfulness
- headache
- joint_pain
- muscle_aches
- breast_tenderness
- bloating
- weight_gain_feeling
- vaginal_dryness
- low_libido
- palpitations
- skin_changes
- cycle_irregularity

Use localization keys for all names.

---

# 10. Feature Design

## 10.1 Onboarding
Goals:
- explain value quickly
- highlight privacy
- explain premium lightly
- collect optional context
- keep completion under 60 seconds

Pages:
1. Welcome
2. What you can track
3. Brain Fog Mode intro
4. Doctor report intro
5. Privacy / local-only promise
6. Optional baseline questions
7. Notification permission prompt (later in flow)
8. Premium teaser or continue free

## 10.2 Home Screen
The home screen should show:
- greeting
- today’s status card
- quick action row
- latest trend summary
- medication reminder card
- appointment prep shortcut
- premium upsell if user is free

Primary actions:
- Log today
- Brain Fog Mode
- Medications
- Reports

## 10.3 Daily Check-In (Standard)
Sections:
- overall day rating
- symptom selection
- symptom severity
- mood / energy / sleep sliders
- cycle / bleeding quick log
- triggers
- medication taken toggle
- impact scores
- notes
- save

## 10.4 Brain Fog Mode
Special fast mode for bad days.
Constraints:
- complete in under 20 seconds
- large tap targets
- minimal text
- no nested complexity

Include:
- “Today feels: bad / okay / good”
- 6 pinned common symptoms
- quick note via text or voice placeholder button
- save instantly

## 10.5 Symptoms Picker
Allow:
- search symptoms
- category grouping
- add custom symptom
- select favorites / pinned symptoms

## 10.6 Cycle Log
Allow:
- spotting / flow tracking
- cramps
- note
- irregularity awareness

## 10.7 Medication / Supplement Log
Allow:
- add profile
- mark as taken
- view active list
- record perceived effect
- note side effects

## 10.8 Insights Overview
Cards:
- symptom trends
- sleep and mood patterns
- brain fog frequency
- period irregularity summary
- likely recurring triggers
- possible helpful factors

Insights language must be cautious.
Never diagnose.
Use phrasing like:
- “You seem to notice…”
- “In the last 30 days…”
- “This may be associated with…”

## 10.9 Correlation Detail
Examples:
- low sleep vs brain fog
- alcohol vs night sweats
- cycle irregularity vs mood swings

This can be heuristic-based for MVP, no heavy ML needed.

## 10.10 Appointment Builder
Generate a clean prep summary for doctor visits.
Include:
- time range
- top 5 symptoms
- symptom frequency
- medication summary
- cycle summary
- user notes
- suggested doctor questions

## 10.11 Reports Export
Generate PDF reports.
At minimum support:
- doctor report
- self summary
- partner explain page scaffold

## 10.12 Settings
Include:
- language
- notifications
- Face ID toggle
- export / backup placeholder
- premium status
- legal pages
- privacy statement

## 10.13 Privacy / Security
Explain:
- no account
- no server
- local data storage
- optional Health access
- optional Face ID lock

## 10.14 Health Access
For MVP, create integration scaffold with permission explanation pages.
Implement only safe read-only placeholders initially if needed.

---

# 11. Information Architecture

Tab structure for MVP:
- Home
- Log
- Insights
- Reports
- Settings

Suggested navigation:
- `TabView` as main shell
- `NavigationStack` inside each tab

---

# 12. UI System

## 12.1 Visual Style
Design goals:
- soft premium healthcare aesthetic
- warm neutral palette
- minimal clutter
- high legibility
- large controls
- accessible spacing

## 12.2 Suggested Color Roles
Do not hardcode random colors everywhere.
Create a theme system.

Use semantic tokens:
- backgroundPrimary
- backgroundSecondary
- cardBackground
- textPrimary
- textSecondary
- accentPrimary
- accentSecondary
- success
- warning
- error
- premium

## 12.3 Typography
Use Apple system font.
Prefer semantic styles.
Examples:
- largeTitle
- title2
- title3
- headline
- body
- callout
- footnote

## 12.4 Accessibility
Must support:
- Dynamic Type
- VoiceOver labels on key controls
- High contrast-friendly color choices
- Minimum 44x44 tap target

---

# 13. Folder Structure

Codex must create this exact structure inside the project root.

```text
PeriMeno/
├── PeriMeno.xcodeproj
├── README.md
├── master-spec.md
├── Docs/
│   ├── Product/
│   │   ├── ProductVision.md
│   │   ├── FeatureScope.md
│   │   └── LocalizationPlan.md
│   ├── Design/
│   │   ├── DesignTokens.md
│   │   ├── UXWriting.md
│   │   └── AccessibilityChecklist.md
│   ├── Engineering/
│   │   ├── Architecture.md
│   │   ├── DataModel.md
│   │   ├── StoreKitPlan.md
│   │   ├── HealthKitPlan.md
│   │   └── ReportingPlan.md
│   └── QA/
│       ├── MVPTestChecklist.md
│       └── LaunchChecklist.md
├── PeriMenoApp/
│   ├── App/
│   │   ├── PeriMenoApp.swift
│   │   ├── AppRouter.swift
│   │   ├── AppState.swift
│   │   └── RootTabView.swift
│   ├── Core/
│   │   ├── Models/
│   │   │   ├── UserProfile.swift
│   │   │   ├── DailyEntry.swift
│   │   │   ├── SymptomLog.swift
│   │   │   ├── CustomSymptom.swift
│   │   │   ├── TriggerLog.swift
│   │   │   ├── CycleLog.swift
│   │   │   ├── MedicationProfile.swift
│   │   │   ├── MedicationEvent.swift
│   │   │   ├── InsightSnapshot.swift
│   │   │   └── AppointmentPrep.swift
│   │   ├── Constants/
│   │   │   ├── SymptomCatalog.swift
│   │   │   ├── TriggerCatalog.swift
│   │   │   ├── PremiumProducts.swift
│   │   │   └── AppConstants.swift
│   │   ├── Extensions/
│   │   │   ├── Date+Formatting.swift
│   │   │   ├── Color+Theme.swift
│   │   │   └── View+Helpers.swift
│   │   └── Utilities/
│   │       ├── Logger.swift
│   │       ├── Haptics.swift
│   │       └── Validators.swift
│   ├── Services/
│   │   ├── Persistence/
│   │   │   ├── PersistenceController.swift
│   │   │   └── PreviewDataFactory.swift
│   │   ├── Insights/
│   │   │   ├── InsightEngine.swift
│   │   │   ├── CorrelationEngine.swift
│   │   │   └── StageHintEngine.swift
│   │   ├── Reports/
│   │   │   ├── PDFReportBuilder.swift
│   │   │   └── ReportTemplates.swift
│   │   ├── Premium/
│   │   │   ├── PremiumManager.swift
│   │   │   └── PurchaseState.swift
│   │   ├── Health/
│   │   │   ├── HealthKitManager.swift
│   │   │   └── HealthPermissionState.swift
│   │   ├── Security/
│   │   │   └── BiometricLockManager.swift
│   │   └── Localization/
│   │       └── LocalizationManager.swift
│   ├── Shared/
│   │   ├── Components/
│   │   │   ├── PMButton.swift
│   │   │   ├── PMCard.swift
│   │   │   ├── PMSectionHeader.swift
│   │   │   ├── PMSymptomChip.swift
│   │   │   ├── PMStatCard.swift
│   │   │   ├── PMEmptyStateView.swift
│   │   │   └── PMPremiumBadge.swift
│   │   ├── Theme/
│   │   │   ├── Theme.swift
│   │   │   ├── ThemeColors.swift
│   │   │   ├── ThemeSpacing.swift
│   │   │   └── ThemeTypography.swift
│   │   └── Helpers/
│   │       └── SampleData.swift
│   ├── Features/
│   │   ├── Onboarding/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── Home/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── LogEntry/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── BrainFogMode/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── Symptoms/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── Cycle/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── Medications/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── Insights/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── AppointmentBuilder/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── Reports/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   ├── Paywall/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   └── Settings/
│   │       ├── Views/
│   │       ├── ViewModels/
│   │       └── Models/
│   ├── Resources/
│   │   ├── Assets.xcassets/
│   │   ├── Preview Content/
│   │   ├── Localization/
│   │   │   └── Localizable.xcstrings
│   │   └── Config/
│   │       └── AppConfiguration.plist
│   └── SupportingFiles/
│       ├── Info.plist
│       └── PeriMeno.entitlements
├── PeriMenoTests/
│   ├── Core/
│   ├── Services/
│   ├── Features/
│   └── TestUtilities/
└── PeriMenoUITests/
    ├── Onboarding/
    ├── Logging/
    ├── Insights/
    └── Premium/
```

---

# 14. Initial File Requirements

Codex must create starter implementations for these critical files.

## 14.1 App bootstrap files
- `PeriMenoApp.swift`
- `AppState.swift`
- `RootTabView.swift`
- `AppRouter.swift`

## 14.2 Persistence
- `PersistenceController.swift`
- SwiftData container setup
- in-memory preview support

## 14.3 Premium scaffold
- `PremiumProducts.swift`
- `PremiumManager.swift`
- `PurchaseState.swift`

Product IDs (placeholder for now):
- `com.perimeno.premium.monthly`
- `com.perimeno.premium.yearly`
- `com.perimeno.lifetime`

## 14.4 Insight scaffold
- `InsightEngine.swift`
- `CorrelationEngine.swift`
- `StageHintEngine.swift`

## 14.5 Report scaffold
- `PDFReportBuilder.swift`

## 14.6 Shared components
Create reusable base components for consistent UI.

---

# 15. MVP Screen-by-Screen Requirements

## 15.1 Home Screen Requirements
Must show:
- today card
- quick log CTA
- brain fog CTA
- recent symptom summary
- premium prompt when free

## 15.2 Log Entry Screen Requirements
Must allow:
- selecting symptoms
- setting severity
- entering mood / energy / sleep scores
- optional notes
- save entry

## 15.3 Brain Fog Mode Requirements
Must:
- use extra-large controls
- minimal cognitive load
- no more than one main screen
- allow save in under 20 seconds

## 15.4 Insights Screen Requirements
Must:
- show cards or summary rows
- use sample / real data
- gracefully handle empty state

## 15.5 Reports Screen Requirements
Must:
- show export options
- allow preview placeholder
- gate premium reports if unpaid

## 15.6 Settings Screen Requirements
Must include:
- language placeholder
- premium status
- privacy statement link placeholder
- Face ID toggle placeholder
- Health permissions entry point

---

# 16. Premium Gating Rules

Free users:
- can create entries
- can use basic tracking
- can use basic Brain Fog quick-entry mode
- can see only short history
- can see locked premium cards

Premium users:
- unlock full insights
- unlock full export
- unlock unlimited history
- unlock advanced Brain Fog templates, shortcuts, and longer-history convenience features
- unlock advanced features

Implement premium gating via central helper, not scattered ad hoc checks.

---

# 17. Analytics Policy

No third-party analytics SDK in MVP.
No external telemetry.
If internal event logging is needed, keep it local-only and debug-only.

---

# 18. Privacy Rules

Hard requirements:
- no account
- no remote sync
- no advertising SDK
- no third-party trackers
- HealthKit permissions must be explicit and optional
- explain data storage clearly in settings

---

# 19. PDF Report Requirements

Create doctor report structure with:
- app title
- date range
- summary block
- symptom frequency table
- top symptoms
- cycle notes
- medication notes
- user notes
- footer disclaimer

Disclaimer example:
“This report is for personal tracking and discussion support. It is not a diagnosis or medical advice.”

---

# 20. App Store / Legal Copy Guidance

Avoid medical claims like:
- diagnose
- cure
- treat
- medical advice replacement

Preferred wording:
- track
- understand
- prepare
- notice patterns
- support conversations with your clinician

---

# 21. Testing Requirements

## 21.1 Unit Tests
Add initial tests for:
- insight engine heuristics
- correlation engine basic output
- premium product identifiers
- sample data generation

## 21.2 UI Tests
Add initial smoke tests for:
- onboarding flow opens
- root tab renders
- user can create a daily entry
- premium screen opens

---

# 22. Launch Readiness for MVP

The first Xcode project generated by Codex does not need all features complete, but must include:
- valid compiling project
- working tab shell
- working data model scaffold
- at least 3 working screens
- premium scaffold
- report scaffold
- localization scaffold
- folder structure created correctly

---

# 23. Codex Execution Instructions

Codex must perform the following in order using Computer Use on the Mac:

## Step 1 — Prepare workspace
1. Open Finder
2. Create a new root folder on Desktop named `PeriMeno`
3. Inside it, create the folder structure defined in this spec where possible
4. Save this file as `master-spec.md` in the project root

## Step 2 — Open Xcode
1. Launch Xcode
2. Create a new iOS App project
3. Product Name: `PeriMeno`
4. Interface: SwiftUI
5. Language: Swift
6. Use SwiftData storage if available in template options
7. Disable Core Data if SwiftData template already covers persistence
8. Save the project into the `Desktop/PeriMeno/` folder

## Step 3 — Add project groups and folders
In Xcode, create groups that mirror the folder structure for:
- App
- Core
- Services
- Shared
- Features
- Resources
- SupportingFiles
- Tests

## Step 4 — Create starter files
Codex must create all starter Swift files listed in this spec, even if some contain placeholders.

## Step 5 — Implement compile-safe MVP shell
Codex must ensure the project builds successfully with:
- App entry point
- RootTabView
- placeholder Home screen
- placeholder Log screen
- placeholder Insights screen
- placeholder Reports screen
- placeholder Settings screen

## Step 6 — Add models
Codex must add SwiftData models for the core domain types.

## Step 7 — Add services
Codex must add scaffold services with compile-safe placeholder logic.

## Step 8 — Add reusable theme and components
Codex must add a minimal theme and at least the shared components listed.

## Step 9 — Run build
Codex must attempt a build in Xcode and fix compile errors.

## Step 10 — Stop and summarize
After successful build, Codex should summarize:
- what was created
- what compiles now
- what remains for next phase

---

# 24. Codex Prompt To Execute

Use this exact instruction as the main execution prompt for Codex:

```md
Read the attached `master-spec.md` and use Computer Use to set up the full local iOS project on this Mac.

Requirements:
1. Create the root folder `PeriMeno` on the Desktop.
2. Create the Xcode SwiftUI iOS app project named `PeriMeno` inside that folder.
3. Build the folder and group structure exactly as defined in `master-spec.md`.
4. Create all scaffold files listed in the spec.
5. Implement a compile-safe MVP shell using SwiftUI + SwiftData.
6. Add placeholder but well-structured implementations for premium, insights, reporting, localization, and HealthKit scaffolds.
7. Make sure all user-facing strings are ready for localization.
8. Build the app in Xcode and fix any compile errors.
9. Do not skip files just because they are placeholders.
10. When finished, provide a concise summary of created folders, major files, and remaining next steps.

Important constraints:
- No server
- No ads
- No third-party analytics
- Offline-first
- Privacy-first
- Use simple MVVM
- Keep code clean and readable
- Prefer semantic naming
- Do not overengineer
- Ensure the project compiles
```

---

# 25. Deliverable Standard

The resulting local project should be good enough that the next phase can immediately continue with:
- screen implementation
- premium purchase flow
- PDF report generation
- insight rules
- localization filling

This master spec is the authority unless explicitly updated later.
