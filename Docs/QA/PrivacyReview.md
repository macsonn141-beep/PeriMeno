# Privacy Review

Last reviewed: 2026-05-19

## Baseline

PeriMeno is offline-first for MVP. The app must not require an account, server sync, ads, or third-party analytics. Health data, symptom logs, medication notes, appointment prep, and report previews stay on device unless the user explicitly exports or shares them through iOS system controls.

## HealthKit Flow

Status: optional, read-only scaffold.

Approved boundaries:

- Ask for Health access only after the user opens the health education/settings flow.
- Explain each requested data category before the iOS permission sheet appears.
- Read only the minimum HealthKit types required for the selected feature.
- Do not write to HealthKit in MVP.
- Do not use HealthKit data for ads, tracking, external analytics, or server-side profiling.
- Allow the app to remain useful when permission is denied.
- Keep HealthKit-derived insights clearly labeled as estimates or context, not diagnoses.

Pre-launch checks:

- Confirm `NSHealthShareUsageDescription` is specific, plain-language, and aligned with actual reads.
- Confirm entitlements are enabled only when HealthKit is intentionally activated for a build.
- Verify denied, restricted, and not-determined permission states in simulator or device testing.
- Verify no HealthKit read is attempted before user intent is established.

## Report Export Flow

Status: local preview/PDF scaffold.

Approved boundaries:

- Generate report previews locally from on-device entries.
- Treat exported PDFs as user-controlled files.
- Use iOS share/export surfaces so the user chooses the destination.
- Show enough preview content for the user to understand what will be included before export.
- Avoid silently attaching identifiers, device metadata, analytics IDs, or hidden tracking fields.
- Make premium gating about feature access only, not access to the user's own raw local data.

Pre-launch checks:

- Confirm generated reports include only selected date ranges and selected report sections.
- Confirm appointment prep and medication details are not included unless selected.
- Confirm PDF files are not cached longer than needed after export/share.
- Confirm failed export states do not leave stale report files in a shared location.
- Confirm report copy avoids medical certainty and encourages clinician review where appropriate.

## Required Manual Review Before Release

- Review all permission strings in `Info.plist`.
- Review `PrivacyInfo.xcprivacy` against actual SDK and data use.
- Run a manual no-network privacy pass on first launch, logging, Health access, reports, and paywall.
- Review App Store privacy nutrition labels after final feature scope is frozen.
- Re-run this review when HealthKit, cloud sync, analytics, or StoreKit behavior changes.
