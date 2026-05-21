import Foundation

@MainActor
final class PaywallViewModel: ObservableObject {
    let plans = [
        PaywallPlan(id: PremiumProducts.monthly, title: "paywall.monthly", price: "paywall.monthly.price"),
        PaywallPlan(id: PremiumProducts.yearly, title: "paywall.yearly", price: "paywall.yearly.price"),
        PaywallPlan(id: PremiumProducts.lifetime, title: "paywall.lifetime", price: "paywall.lifetime.price")
    ]
}
