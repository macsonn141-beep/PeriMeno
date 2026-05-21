import Foundation

enum PremiumProducts {
    static let monthly = "com.perimeno.premium.monthly"
    static let yearly = "com.perimeno.premium.yearly"
    static let lifetime = "com.perimeno.lifetime"

    static let orderedIdentifiers = [
        monthly,
        yearly,
        lifetime
    ]

    static let allIdentifiers = Set(orderedIdentifiers)

    static func kind(for productID: String) -> PremiumProductKind {
        switch productID {
        case monthly, yearly:
            return .subscription
        case lifetime:
            return .lifetime
        default:
            return .unknown
        }
    }
}

enum PremiumProductKind: String {
    case subscription
    case lifetime
    case unknown
}
