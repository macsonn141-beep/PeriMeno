# Language Switcher Home UI Report

## Summary

The language switcher was moved out of the Settings preferences section and into the Home screen header as a compact secondary utility button beside the Home label. A follow-up localization pass also made the main app flows visibly switch to Simplified and Traditional Chinese instead of leaving most screens in English.

## What Changed

- Removed the full Settings language picker from `SettingsView`.
- Added a compact Home header language button with a globe icon, current language code, and menu picker.
- Reused the existing `settings.languageCode` `AppStorage` key so language changes still update the app locale.
- Reused `LocalizationManager.supportedLanguages` and existing localized language names.
- Forced the root SwiftUI tree to refresh when `settings.languageCode` changes so the selected locale is applied immediately.
- Added real localized values for the main visible Home strings in Japanese and Chinese, plus broader Home placeholder coverage across the 15-language scaffold, so switching no longer appears unchanged on Home.
- Updated the Today summary labels to resolve against the selected app locale.
- Added Simplified and Traditional Chinese coverage for the main user-facing app flows: Home, Log, Brain Fog Mode, Insights, Reports, Settings, Privacy, Health Access, Paywall, Onboarding, History, Entry Detail/Edit/Delete, Symptoms, Triggers, Medications, Cycle, Appointment prep, PDF report labels, alerts, empty states, and tab labels.
- Added visible localization coverage for the remaining planned languages: Spanish, Portuguese (Brazil), French, German, Italian, Japanese, Korean, Arabic, Hindi, Indonesian, Turkish, and Thai.
- Replaced dynamic `String(localized:)` calls in ViewModels and services with app-locale-aware lookup so generated summaries, paywall messages, PDF/report text, history rows, and insights read the selected app language.
- Localized dynamic symptom and trigger names in Home, Insights, History, and Entry Detail instead of showing fallback English names such as `Hot Flashes`.
- Synchronized the Home language picker with `LocalizationManager.selectedLanguageCode` as well as `settings.languageCode`.

## Current Location

The language switcher now lives in the top-right of the Home header row, beside the `HOME` label.

## Interaction

Tapping the current language label opens a compact menu with all supported languages. Selecting a language writes to `settings.languageCode`, which is already consumed by `PeriMenoApp` to update locale and layout direction.

## Verification

- Build command passed:

```bash
xcodebuild -project PeriMeno.xcodeproj -scheme PeriMeno -destination 'platform=iOS Simulator,name=iPhone 17' build
```

- App was installed and launched in the booted iPhone 17 Simulator.
- Home was visually checked in Simulator. The compact language button appears in the top-right header area and localized Home strings render when a non-English language is selected.
- Simplified Chinese launch was checked in Simulator. Home hero, Today summary, quick action tiles, and bottom tab labels rendered in Chinese.
- Spanish launch was checked in Simulator. Home hero, Today summary, quick action tiles, and bottom tab labels rendered in Spanish.
- Indonesian, Turkish, and Thai launches were checked in the iPhone 17 Simulator. Home hero, premium CTA, Today summary, dynamic symptom name, quick action tiles, and bottom tab labels rendered in the selected language.
- Remaining Simplified/Traditional keys equal to English are only non-user-facing/special cases: `battery.25`, `language.chineseSimplified`, and `language.chineseTraditional`.
- Batch 1 localization cleanup completed for Spanish, Portuguese (Brazil), and French. Each of these now has `0` language-marked fallback strings remaining in `Localizable.xcstrings`.
- Batch 2 localization cleanup completed for German, Italian, and Japanese. Each of these now has `0` language-marked fallback strings remaining in `Localizable.xcstrings`.
- Batch 3 localization cleanup completed for Korean, Arabic, and Hindi. Each of these now has `0` language-marked fallback strings remaining in `Localizable.xcstrings`.
- Batch 4 localization cleanup completed for Indonesian, Turkish, and Thai. Each of these now has `0` language-marked fallback strings remaining in `Localizable.xcstrings`.

## Notes

- The Home placement is intentionally visually secondary and should not compete with Log Today, Brain Fog Mode, Reports, or Subscribe.
- Settings still contains notification and Face ID preferences, but no longer shows the oversized language picker.
- Simplified Chinese, Traditional Chinese, Spanish, Portuguese (Brazil), French, German, Italian, Japanese, Korean, Arabic, Hindi, Indonesian, Turkish, and Thai are covered for MVP manual testing.
- All language-marked scaffold fallback prefixes for the 12 expanded languages are now removed.
