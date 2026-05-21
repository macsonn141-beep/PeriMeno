import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = PaywallViewModel()
    @StateObject private var premiumManager = PremiumManager()
    @State private var paywallMessage: String?
    @State private var selectedProductID: String?

    var body: some View {
        List {
            Section {
                Text("paywall.subtitle")
                    .foregroundStyle(.secondary)
                Text(statusText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                if let activeProductText {
                    Text(activeProductText)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(ThemeColors.accentPrimary)
                }
            }

            Section("paywall.section.plans") {
                ForEach(viewModel.plans) { plan in
                    let product = premiumManager.products.first { $0.id == plan.id }
                    Button {
                        Task {
                            if let product {
                                selectedProductID = product.id
                                let didUnlock = await premiumManager.purchase(product)
                                appState.isPremiumUnlocked = premiumManager.purchaseState.isPremium
                                paywallMessage = didUnlock
                                    ? successMessage(for: product.id)
                                    : feedbackMessage
                                selectedProductID = nil
                            } else {
                                #if DEBUG
                                let didUnlock = premiumManager.unlockForLocalTesting(productID: plan.id)
                                appState.isPremiumUnlocked = premiumManager.purchaseState.isPremium
                                paywallMessage = didUnlock
                                    ? successMessage(for: plan.id)
                                    : String(localized: "paywall.productsUnavailable")
                                #else
                                paywallMessage = String(localized: "paywall.productsUnavailable")
                                #endif
                                Logger.debug("StoreKit product metadata is not available yet.")
                            }
                        }
                    } label: {
                        PMCard {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(plan.title)
                                        .font(.headline)
                                    Text(product?.displayPrice ?? String(localized: plan.price))
                                        .foregroundStyle(.secondary)
                                    Text(kindText(for: plan.id))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                trailingStatus(for: plan.id)
                            }
                        }
                    }
                    .disabled(premiumManager.purchaseState == .loading)
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                if premiumManager.products.isEmpty && premiumManager.purchaseState != .loading {
                    VStack(alignment: .leading, spacing: ThemeSpacing.xSmall) {
                        Text("paywall.diagnostic.title")
                            .font(.footnote.weight(.semibold))
                        Text(premiumManager.productLoadDiagnostic.message)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("paywall.localTestingFallback")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                Button("paywall.restore") {
                    Task {
                        let didRestore = await premiumManager.restorePurchases()
                        appState.isPremiumUnlocked = premiumManager.purchaseState.isPremium
                        paywallMessage = didRestore
                            ? String(localized: "paywall.restore.premium")
                            : String(localized: "paywall.restore.none")
                    }
                }
                .disabled(premiumManager.purchaseState == .loading)
            }
        }
        .navigationTitle("paywall.title")
        .alert("paywall.feedback.title", isPresented: paywallMessageIsPresented) {
            Button("common.ok", role: .cancel) {
                paywallMessage = nil
            }
        } message: {
            Text(paywallMessage ?? "")
        }
        .task {
            await premiumManager.loadProducts()
            await premiumManager.syncEntitlements()
            appState.isPremiumUnlocked = premiumManager.purchaseState.isPremium
        }
    }

    private var paywallMessageIsPresented: Binding<Bool> {
        Binding {
            paywallMessage != nil
        } set: { isPresented in
            if !isPresented {
                paywallMessage = nil
            }
        }
    }

    private var statusText: LocalizedStringResource {
        if premiumManager.purchaseState.isPremium || appState.isPremiumUnlocked {
            return "paywall.status.premium"
        }

        switch premiumManager.purchaseState {
        case .loading:
            return "paywall.status.loading"
        case .failed:
            return "paywall.status.failed"
        default:
            return "paywall.status.free"
        }
    }

    private var activeProductText: String? {
        guard let productID = premiumManager.purchaseState.productID else { return nil }
        switch PremiumProducts.kind(for: productID) {
        case .subscription:
            return String(localized: "paywall.active.subscription")
        case .lifetime:
            return String(localized: "paywall.active.lifetime")
        case .unknown:
            return nil
        }
    }

    private var feedbackMessage: String {
        switch premiumManager.purchaseState {
        case .failed(let message):
            return message
        case .loading:
            return String(localized: "paywall.purchase.pending")
        case .free:
            return String(localized: "paywall.purchase.cancelled")
        case .premium(let productID):
            return successMessage(for: productID)
        case .unknown:
            return String(localized: "paywall.status.failed")
        }
    }

    @ViewBuilder
    private func trailingStatus(for productID: String) -> some View {
        if premiumManager.purchaseState.productID == productID {
            Label("paywall.plan.active", systemImage: "checkmark.seal.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(ThemeColors.accentPrimary)
        } else if selectedProductID == productID && premiumManager.purchaseState == .loading {
            ProgressView()
        } else {
            PMPremiumBadge()
        }
    }

    private func kindText(for productID: String) -> String {
        switch PremiumProducts.kind(for: productID) {
        case .subscription:
            return String(localized: "paywall.kind.subscription")
        case .lifetime:
            return String(localized: "paywall.kind.lifetime")
        case .unknown:
            return ""
        }
    }

    private func successMessage(for productID: String) -> String {
        switch PremiumProducts.kind(for: productID) {
        case .subscription:
            return String(localized: "paywall.purchase.subscriptionSuccess")
        case .lifetime:
            return String(localized: "paywall.purchase.lifetimeSuccess")
        case .unknown:
            return String(localized: "paywall.purchase.success")
        }
    }
}
