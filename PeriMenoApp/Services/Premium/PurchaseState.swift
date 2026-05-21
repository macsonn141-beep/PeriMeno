import Foundation

enum PurchaseState: Equatable {
    case unknown
    case free
    case premium(productID: String)
    case loading
    case failed(message: String)

    var isPremium: Bool {
        if case .premium = self { return true }
        return false
    }

    var productID: String? {
        if case .premium(let productID) = self { return productID }
        return nil
    }

    var productKind: PremiumProductKind {
        guard let productID else { return .unknown }
        return PremiumProducts.kind(for: productID)
    }
}
