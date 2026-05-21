# Phase 3 StoreKit Injection Debug Report

Date: 2026-05-21

## A. Native StoreKit Local Testing Status

Native StoreKit local testing now works in Xcode / Simulator.

Verified behavior:

- Xcode scheme Run > Options now shows `StoreKit Configuration: PeriMeno.storekit`.
- Paywall loads native StoreKit product metadata.
- Paywall prices now come from `PeriMeno.storekit`:
  - Monthly: `$4.99`
  - Yearly: `$39.99`
  - Lifetime: `$29.99`
- Monthly native local purchase sheet appeared.
- Local monthly subscription purchase completed successfully.
- App showed purchase success confirmation.
- Paywall changed Monthly to `Active`.
- Local premium state persisted in Simulator preferences:

`perimeno.premium.productID = com.perimeno.premium.monthly`

## B. Exact Blocker Found

The active Xcode Run scheme was not actually loading the StoreKit configuration.

Observed in Xcode:

- Product > Scheme > Edit Scheme > Run > Options
- StoreKit Configuration initially displayed `None`.

When selecting `PeriMeno.storekit`, Xcode showed the broken path:

`/Users/macsonnnnui/Desktop/PeriMeno/PeriMeno.xcodeproj/PeriMenoApp/Resources/Config/PeriMeno.storekit`

That path is wrong because it resolves inside the `.xcodeproj` bundle.

The scheme was corrected to:

`../../PeriMenoApp/Resources/Config/PeriMeno.storekit`

After that, Xcode Run > Options showed `PeriMeno.storekit` without the file-not-found warning, and StoreKit metadata loaded in Simulator.

## C. Product Identifier Validation

Validated exact product ID match across:

- `PeriMenoApp/Resources/Config/PeriMeno.storekit`
- `PeriMenoApp/Core/Constants/PremiumProducts.swift`
- `PremiumManager`
- `PaywallView`

Expected and verified IDs:

- `com.perimeno.premium.monthly`
- `com.perimeno.premium.yearly`
- `com.perimeno.lifetime`

Validation result:

`expected_match=true`

## D. Files Changed

- `PeriMeno.xcodeproj/xcshareddata/xcschemes/PeriMeno.xcscheme`
  - Fixed StoreKit configuration path to `../../PeriMenoApp/Resources/Config/PeriMeno.storekit`.
- `PeriMenoApp/Services/Premium/PremiumManager.swift`
  - Added product-fetch diagnostics.
  - Logs requested product IDs.
  - Logs returned product count.
  - Logs returned product IDs.
  - Tracks fetch status in `PremiumProductLoadDiagnostic`.
- `PeriMenoApp/Features/Paywall/Views/PaywallView.swift`
  - Shows clearer StoreKit diagnostic UI only when products are unavailable.
  - Keeps debug fallback available after reporting why native StoreKit did not load.
- `PeriMenoApp/Resources/Localization/Localizable.xcstrings`
  - Added localization-ready diagnostic strings.

## E. Logging Added

`PremiumManager.loadProducts()` now logs:

- requested product IDs
- returned product count
- returned product IDs
- empty-response diagnosis
- fetch failure reason

Example intent:

```text
StoreKit product fetch requested IDs: com.perimeno.premium.monthly, com.perimeno.premium.yearly, com.perimeno.lifetime
StoreKit product fetch returned count: 3
StoreKit product fetch returned IDs: com.perimeno.lifetime, com.perimeno.premium.monthly, com.perimeno.premium.yearly
```

## F. Clean Run Steps Performed

- Confirmed product IDs match.
- Opened Xcode scheme editor.
- Checked Run > Options.
- Set StoreKit Configuration to `PeriMeno.storekit`.
- Confirmed Xcode no longer showed the file-not-found warning.
- Ran `xcodebuild clean`.
- Uninstalled `com.perimeno.app` from the iPhone 17 Pro Simulator.
- Restarted Simulator.
- Rebuilt successfully.
- Relaunched from Xcode.
- Completed onboarding.
- Opened Reports > premium paywall.
- Verified native StoreKit prices appeared.
- Completed native monthly local purchase.

## G. Fallback Mode

Fallback mode remains in place.

It now only appears when native StoreKit metadata is unavailable, and the paywall shows a diagnostic message first:

- metadata not requested
- metadata loading
- native metadata loaded
- StoreKit returned zero products
- StoreKit fetch failed

This keeps Simulator testing usable while making native StoreKit failures explicit.

## H. Build Result

Command:

```sh
xcodebuild -project PeriMeno.xcodeproj -scheme PeriMeno -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

Result:

`BUILD SUCCEEDED`

## I. Remaining Notes

- Monthly native local purchase was verified end-to-end.
- Yearly and lifetime metadata loaded, but their purchase flows were not repeated after monthly activation.
- The StoreKit config path is sensitive to Xcode's scheme-relative resolution. If this regresses, check Run > Options first before debugging app code.
