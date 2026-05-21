import Foundation
import StoreKit

@MainActor
final class PremiumManager: ObservableObject {
    @Published private(set) var purchaseState: PurchaseState
    @Published private(set) var products: [Product] = []
    @Published private(set) var lastPurchasedProductID: String?
    @Published private(set) var productLoadDiagnostic: PremiumProductLoadDiagnostic = .notRequested

    private let defaults: UserDefaults
    private var updatesTask: Task<Void, Never>?

    private enum DefaultsKey {
        static let premiumProductID = "perimeno.premium.productID"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let productID = defaults.string(forKey: DefaultsKey.premiumProductID),
           PremiumProducts.allIdentifiers.contains(productID) {
            purchaseState = .premium(productID: productID)
            lastPurchasedProductID = productID
        } else {
            purchaseState = .free
        }

        updatesTask = observeTransactionUpdates()
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProducts() async {
        purchaseState = .loading
        productLoadDiagnostic = .loading(requestedIDs: PremiumProducts.orderedIdentifiers)
        Logger.debug("StoreKit product fetch requested IDs: \(PremiumProducts.orderedIdentifiers.joined(separator: ", "))")
        do {
            let fetchedProducts = try await Product.products(for: PremiumProducts.orderedIdentifiers)
            products = PremiumProducts.orderedIdentifiers.compactMap { productID in
                fetchedProducts.first { $0.id == productID }
            }
            let returnedIDs = fetchedProducts.map(\.id).sorted()
            Logger.debug("StoreKit product fetch returned count: \(fetchedProducts.count)")
            Logger.debug("StoreKit product fetch returned IDs: \(returnedIDs.joined(separator: ", "))")
            if products.isEmpty {
                productLoadDiagnostic = .emptyResponse(requestedIDs: PremiumProducts.orderedIdentifiers)
                Logger.debug("StoreKit product metadata unavailable. The local StoreKit configuration may not be injected into this run.")
            } else {
                productLoadDiagnostic = .loaded(returnedIDs: returnedIDs)
            }
            if !purchaseState.isPremium {
                purchaseState = .free
            }
        } catch {
            productLoadDiagnostic = .failed(message: error.localizedDescription)
            Logger.debug("StoreKit product fetch failed: \(error.localizedDescription)")
            purchaseState = .failed(message: error.localizedDescription)
        }
    }

    @discardableResult
    func purchase(_ product: Product) async -> Bool {
        purchaseState = .loading

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    unlock(productID: transaction.productID)
                    await transaction.finish()
                    return true
                case .unverified:
                    purchaseState = .failed(message: String(localized: "premium.purchase.unverified"))
                }
            case .userCancelled:
                restorePersistedStateOrFree()
            case .pending:
                purchaseState = .loading
            @unknown default:
                purchaseState = .failed(message: String(localized: "premium.purchase.unknown"))
            }
        } catch {
            purchaseState = .failed(message: error.localizedDescription)
        }

        return false
    }

    @discardableResult
    func restorePurchases() async -> Bool {
        #if DEBUG
        if let productID = defaults.string(forKey: DefaultsKey.premiumProductID),
           PremiumProducts.allIdentifiers.contains(productID) {
            unlock(productID: productID)
            return true
        }
        #endif

        do {
            try await AppStore.sync()
        } catch {
            purchaseState = .failed(message: error.localizedDescription)
            return false
        }
        return await syncEntitlements()
    }

    @discardableResult
    func syncEntitlements() async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               PremiumProducts.allIdentifiers.contains(transaction.productID) {
                unlock(productID: transaction.productID)
                return true
            }
        }
        restorePersistedStateOrFree()
        return purchaseState.isPremium
    }

    func clearLocalPremiumState() {
        defaults.removeObject(forKey: DefaultsKey.premiumProductID)
        lastPurchasedProductID = nil
        purchaseState = .free
    }

    #if DEBUG
    func unlockForLocalTesting(productID: String) -> Bool {
        guard PremiumProducts.allIdentifiers.contains(productID) else { return false }
        unlock(productID: productID)
        return true
    }
    #endif

    func canAccess(_ feature: PremiumFeatureGate) -> Bool {
        // MVP decision: basic tracking and basic Brain Fog remain free; advanced history, reports, correlations, and HealthKit enrichment are premium.
        switch feature {
        case .basicTracking, .basicBrainFog:
            true
        case .unlimitedHistory, .advancedBrainFog, .advancedInsights, .fullReports, .healthKit:
            purchaseState.isPremium
        }
    }

    private func unlock(productID: String) {
        guard PremiumProducts.allIdentifiers.contains(productID) else { return }
        defaults.set(productID, forKey: DefaultsKey.premiumProductID)
        lastPurchasedProductID = productID
        purchaseState = .premium(productID: productID)
    }

    private func restorePersistedStateOrFree() {
        if let productID = defaults.string(forKey: DefaultsKey.premiumProductID),
           PremiumProducts.allIdentifiers.contains(productID) {
            purchaseState = .premium(productID: productID)
        } else {
            purchaseState = .free
        }
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                if case .verified(let transaction) = result,
                   PremiumProducts.allIdentifiers.contains(transaction.productID) {
                    await MainActor.run {
                        self.unlock(productID: transaction.productID)
                    }
                    await transaction.finish()
                }
            }
        }
    }
}

enum PremiumFeatureGate {
    case basicTracking
    case basicBrainFog
    case advancedBrainFog
    case unlimitedHistory
    case advancedInsights
    case fullReports
    case healthKit
}

enum PremiumProductLoadDiagnostic: Equatable {
    case notRequested
    case loading(requestedIDs: [String])
    case loaded(returnedIDs: [String])
    case emptyResponse(requestedIDs: [String])
    case failed(message: String)

    var message: String {
        switch self {
        case .notRequested:
            return String(localized: "paywall.diagnostic.notRequested")
        case .loading(let requestedIDs):
            return String(
                format: String(localized: "paywall.diagnostic.loading"),
                requestedIDs.joined(separator: ", ")
            )
        case .loaded(let returnedIDs):
            return String(
                format: String(localized: "paywall.diagnostic.loaded"),
                returnedIDs.joined(separator: ", ")
            )
        case .emptyResponse(let requestedIDs):
            return String(
                format: String(localized: "paywall.diagnostic.empty"),
                requestedIDs.joined(separator: ", ")
            )
        case .failed(let message):
            return String(
                format: String(localized: "paywall.diagnostic.failed"),
                message
            )
        }
    }
}
