import SwiftUI

struct PMEmptyStateView: View {
    let title: LocalizedStringResource
    let message: LocalizedStringResource
    let systemImage: String

    var body: some View {
        PMCard {
            VStack(spacing: ThemeSpacing.medium) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .foregroundStyle(ThemeColors.accentPrimary)
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
