import SwiftUI

struct PMPremiumBadge: View {
    var body: some View {
        Label("premium.badge", systemImage: "sparkles")
            .font(.caption.weight(.semibold))
            .padding(.horizontal, ThemeSpacing.small)
            .padding(.vertical, ThemeSpacing.xSmall)
            .background(ThemeColors.premium.opacity(0.16), in: Capsule())
            .foregroundStyle(ThemeColors.premium)
    }
}
