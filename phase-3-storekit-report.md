# Phase 3 StoreKit Report

Date: 2026-05-20

## A. What Was Implemented

- Added a local StoreKit configuration file for premium testing.
- Wired the active Xcode scheme to the StoreKit configuration file.
- Centralized premium product IDs and product kind mapping.
- Updated `PremiumManager` to:
  - fetch StoreKit products in configured order
  - purchase verified StoreKit products
  - restore purchases
  - observe StoreKit transaction updates
  - persist unlocked premium state locally with `UserDefaults`
  - distinguish subscription products from lifetime products
- Updated `PaywallView` to:
  - show monthly, yearly, and lifetime plans
  - display loading/free/premium/failure states
  - show active product state
  - show success/failure/cancelled/pending feedback
  - provide a Restore Purchases action
  - avoid dead buttons when StoreKit products are unavailable
- Added a debug-only local purchase fallback for Simulator testing when Xcode does not inject StoreKit products.
- Verified premium-gated Reports behavior unlocks after a local monthly test unlock.

## B. Files Changed

- `PeriMenoApp/Core/Constants/PremiumProducts.swift`
- `PeriMenoApp/Services/Premium/PurchaseState.swift`
- `PeriMenoApp/Services/Premium/PremiumManager.swift`
- `PeriMenoApp/App/AppState.swift`
- `PeriMenoApp/Features/Paywall/Views/PaywallView.swift`
- `PeriMenoApp/Resources/Localization/Localizable.xcstrings`
- `PeriMenoApp/Resources/Config/PeriMeno.storekit`
- `PeriMeno.xcodeproj/project.pbxproj`
- `PeriMeno.xcodeproj/xcshareddata/xcschemes/PeriMeno.xcscheme`

## C. StoreKit Config Added

StoreKit configuration file:

`PeriMenoApp/Resources/Config/PeriMeno.storekit`

Configured products:

- `com.perimeno.premium.monthly`
  - Auto-renewable subscription
  - Local test price: `$4.99`
  - Period: monthly
- `com.perimeno.premium.yearly`
  - Auto-renewable subscription
  - Local test price: `$39.99`
  - Period: yearly
- `com.perimeno.lifetime`
  - Non-consumable
  - Local test price: `$29.99`

The active `PeriMeno` scheme now includes:

`../PeriMenoApp/Resources/Config/PeriMeno.storekit`

## D. What Purchase Flows Now Work

- Paywall opens from premium-gated Reports rows.
- Monthly plan button responds.
- When StoreKit products are available, the purchase flow uses StoreKit `Product.purchase()`.
- When Xcode does not inject StoreKit products, Debug builds use a local Simulator fallback instead of leaving buttons dead.
- Monthly local fallback unlock was manually verified in Simulator.
- Premium state is persisted locally:

`perimeno.premium.productID = com.perimeno.premium.monthly`

- Reports premium rows become usable after unlock:
  - tapping Doctor report produced a report preview instead of routing back to the paywall.
- Restore Purchases now checks persisted debug premium state before calling `AppStore.sync()`, so local fallback restores are testable.
- AppState initializes premium state from local persistence, so premium can survive relaunch in the current architecture.

## E. What Remains Incomplete

- Xcode did not inject StoreKit products during manual Simulator verification on this machine. The paywall showed fallback prices and the debug fallback notice instead of StoreKit product metadata.
- Because StoreKit products were not injected, the native StoreKit confirmation sheet was not manually verified.
- Yearly and lifetime were configured and are button-testable through the same fallback path, but only monthly was manually verified end-to-end.
- Full production commerce is not implemented:
  - no App Store Connect products
  - no receipt/server validation
  - no subscription expiration handling
  - no billing issue handling
  - no real entitlement sync beyond StoreKit current entitlements and local debug persistence

## F. Verification Results

Build:

- `xcodebuild -project PeriMeno.xcodeproj -scheme PeriMeno -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`
- Result: passed

Manual Simulator checks:

- App launched from Xcode: passed
- Paywall opened from Reports premium gate: passed
- StoreKit config available in scheme/debug toolbar: partially verified
- StoreKit products loaded into `Product.products(for:)`: failed in local Xcode run
- Debug local fallback shown clearly: passed
- Monthly plan unlock: passed
- Success confirmation after unlock: passed
- Monthly active state shown on paywall: passed
- Premium state persisted in Simulator preferences: passed
- Reports premium content unlocked after purchase: passed
- Restore path updated to support persisted debug unlocks: implemented, build verified

## G. Recommended Next Phase

1. Recreate the `.storekit` file through Xcode's StoreKit Configuration editor if native product injection remains unavailable.
2. Add a small debug-only Premium Diagnostics screen showing product load count, active product ID, and current entitlement source.
3. Test native StoreKit purchase sheets for monthly, yearly, and lifetime once Xcode injects products.
4. Add subscription expiration and revocation handling for non-debug builds.
5. Decide whether premium state should be managed by a shared `PremiumManager` environment object instead of bridging through `AppState`.

## References

- Apple Developer Documentation: Setting up StoreKit Testing in Xcode
- Apple Developer Documentation: StoreKit `Product`
