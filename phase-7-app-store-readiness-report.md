# Phase 7 App Store Readiness Report

## A. What is already ready for submission

- Core app flows exist and build:
  - Onboarding
  - Home
  - Daily Log
  - Brain Fog Mode
  - Insights
  - Reports
  - Entry History, Detail, Edit, Delete
  - Settings
  - Paywall and StoreKit local testing scaffold
- Local-first privacy positioning is built into the product.
- `PrivacyInfo.xcprivacy` exists and currently declares no tracking or collected data.
- App icon asset catalog exists with iPhone, iPad, and 1024x1024 marketing slots.
- `Info.plist` exists and includes a Health data usage description.
- StoreKit product IDs are centralized and local `.storekit` testing exists.
- PDF reports include a non-diagnosis / non-medical-advice disclaimer.
- Localization scaffold exists for 15 languages.
- Release placeholder structure now exists under `AppStore/`.
- Build passed after Phase 7 changes.

## B. What is still missing

- Real Apple Developer Team is not configured: `DEVELOPMENT_TEAM` is empty.
- Public privacy policy URL now points to the repository privacy policy.
- Public support URL now points to the repository.
- Public marketing URL now points to the repository.
- A monitored support email is still recommended before release.
- App Store Connect app record is not represented in the repo.
- Production in-app purchase products must be created and approved in App Store Connect.
- Final screenshots have not been captured.
- Final App Store metadata is not written:
  - Subtitle
  - Promotional text
  - Description
  - Keywords
  - Review notes
  - Subscription product descriptions
- Professional translation is still needed for non-English storefronts.
- Physical-device QA is still needed before TestFlight or App Review.

## C. What can block App Review

- Missing owned production URLs or monitored support contact details.
- Missing or incorrect App Privacy nutrition labels in App Store Connect.
- Health-related wording that implies diagnosis, treatment, prevention, or medical advice.
- In-app purchases not configured in App Store Connect or not restorable in sandbox.
- HealthKit permission copy or behavior not matching actual usage.
- Premium paywall screenshots or metadata that do not match live product behavior.
- Privacy manifest mismatch if future code adds network calls, analytics, tracking, or collected data.
- Empty `DEVELOPMENT_TEAM` preventing archive/signing for distribution.
- App icon artwork if it is placeholder, copied, low quality, or has invalid alpha on the marketing icon.

## D. Recommended first-release scope

- Ship as an offline-first personal perimenopause/menopause tracking MVP.
- Keep first release focused on:
  - Daily Log
  - Brain Fog Mode
  - Home summaries
  - Entry History and edit/delete
  - Simple Insights
  - Doctor Report and Self Summary PDFs
  - Premium unlock for advanced reports/history/insights
- Avoid first-release claims around diagnosis, treatment, medical prediction, or clinical accuracy.
- Keep account creation, cloud sync, analytics, and server features out of v1 unless privacy documents and App Review metadata are updated.

## E. Suggested screenshots list

### iPhone

1. Onboarding welcome: privacy-first, local-first value.
2. Home screen: latest saved log summary.
3. Daily Log: symptoms and ratings.
4. Brain Fog Mode: large quick-entry controls.
5. Entry History: saved logs list.
6. Insights: simple local summaries.
7. Doctor Report preview: PDF report value.
8. Paywall: monthly, yearly, lifetime options.

### iPad

1. Home with saved data.
2. Daily Log.
3. Insights.
4. Reports / PDF preview.
5. Settings privacy screen.

## F. Suggested metadata checklist

- App name: PeriMeno.
- Subtitle: write final 30-character App Store subtitle.
- Category: likely Health & Fitness; evaluate Medical carefully because medical category increases scrutiny.
- Description: emphasize personal tracking, privacy, local data, and clinician discussion support.
- Keywords: include menopause, perimenopause, symptoms, tracker, brain fog, hot flashes, sleep, mood, report.
- Support URL: replace placeholder with live support page.
- Privacy policy URL: replace placeholder with live privacy policy.
- Marketing URL: optional, but replace placeholder if used.
- Review notes:
  - State that the app is local-first.
  - State that reports are for personal tracking and clinician discussion support only.
  - Explain premium testing with sandbox products.
  - Mention Health access is optional.
- Subscription metadata:
  - Monthly: `com.perimeno.premium.monthly`
  - Yearly: `com.perimeno.premium.yearly`
  - Lifetime: `com.perimeno.lifetime`

## Files added or updated in Phase 7

- `PeriMenoApp/Core/Constants/AppConstants.swift`
- `AppStore/README.md`
- `AppStore/Assets/app-icon-notes.md`
- `AppStore/Screenshots/screenshot-plan.md`
- `AppStore/Metadata/metadata-checklist.md`
- `launch-checklist.md`
- `phase-7-app-store-readiness-report.md`

## Verification

- App icon catalog exists at `PeriMenoApp/Resources/Assets.xcassets/AppIcon.appiconset`.
- Privacy manifest exists at `PeriMenoApp/SupportingFiles/PrivacyInfo.xcprivacy`.
- `Info.plist` includes `NSHealthShareUsageDescription`.
- Build passed:
  - `xcodebuild -project PeriMeno.xcodeproj -scheme PeriMeno -destination 'platform=iOS Simulator,name=iPhone 17' build`
