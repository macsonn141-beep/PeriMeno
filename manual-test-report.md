# PeriMeno Manual QA Report

## Summary

Manual UI testing was completed in Simulator using the iPhone 17 Pro simulator. The app built, installed, launched, completed onboarding, entered the main tab shell, and the initially failed high-impact interactions were repaired and retested.

Final build result: `BUILD SUCCEEDED`

## A. Initial Failed Tests

### Test 6 — Daily Log Flow

Result: Fail

Observed behavior: The Log screen opened and controls were tappable, but the Save action was difficult to reach because it was placed at the bottom of a long form behind the tab/safe-area region.

Fix priority: High

### Test 8 — Insights Rendering

Result: Fail

Observed behavior: Insights loaded, but the visible detail buttons felt dead during manual testing.

Fix priority: Medium

### Test 9 — Reports and Premium Gating

Result: Fail

Observed behavior: Reports loaded, but premium report rows did not clearly open a paywall or locked-state flow.

Fix priority: Medium

### Test 10 — Settings, Privacy, and Premium Entry

Result: Fail

Observed behavior: Toggles worked, but some settings rows felt dead. Placeholder rows only logged debug output and gave no user-visible feedback.

Fix priority: Medium

## B. Root Causes

- `LogEntryView.swift`: Primary Save action was not pinned and could become effectively hidden in a long `Form`.
- `InsightsOverviewView.swift`: Detail actions used manual router path mutation, which was less reliable and less visibly navigational than `NavigationLink`.
- `ReportsExportView.swift`: Premium rows were visually tappable but did not clearly communicate/pay off the locked state.
- `SettingsView.swift`: Placeholder rows had no visible feedback; routed rows lacked clear navigation affordance.

## C. Fixes Applied

- Added a bottom-pinned Save button to Daily Log using `safeAreaInset(edge: .bottom)`.
- Added a visible saved confirmation alert after Daily Log save.
- Replaced Insights detail controls with explicit `NavigationLink` destinations.
- Replaced locked Reports premium rows with explicit `NavigationLink` to Paywall.
- Replaced routed Settings rows with explicit `NavigationLink`.
- Added a “Coming soon” alert for placeholder Settings rows.

## D. Files Changed

- `PeriMenoApp/Features/LogEntry/Views/LogEntryView.swift`
- `PeriMenoApp/Features/Insights/Views/InsightsOverviewView.swift`
- `PeriMenoApp/Features/Reports/Views/ReportsExportView.swift`
- `PeriMenoApp/Features/Settings/Views/SettingsView.swift`

## E. Rerun Results

### Test 6 — Daily Log Flow

Result: Pass

Rerun behavior: Save is visible, tappable, and confirms with a saved alert.

### Test 8 — Insights Rendering

Result: Pass

Rerun behavior: Trend Detail opens from Insights.

### Test 9 — Reports and Premium Gating

Result: Pass

Rerun behavior: Premium report row opens Paywall.

### Test 10 — Settings, Privacy, and Premium Entry

Result: Pass

Rerun behavior: Privacy row opens the Privacy screen; placeholder row shows visible “Coming soon” feedback.

## F. Remaining Issues

- StoreKit purchase flow is still scaffolded. Paywall opens, but real purchases require configured StoreKit products.
- Export and backup / legal copy are still placeholders, but now show visible feedback instead of feeling dead.
- Some placeholder screens are intentionally minimal and should be expanded in the next development phase.

## G. Recommended Next 5 Engineering Tasks

1. Add UI tests for onboarding, tab switching, Daily Log save, and Brain Fog save.
2. Add placeholder detail screens for Export/Backup and Legal copy instead of alert-only feedback.
3. Convert Home quick-action cards to explicit navigation links where practical.
4. Add a non-destructive demo/sample data reset for repeatable manual QA.
5. Configure StoreKit test products and verify Paywall purchase/restore states.

