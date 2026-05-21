import SwiftUI

struct PMStatCard: View {
    let title: LocalizedStringResource
    let value: String
    let systemImage: String

    var body: some View {
        PMCard {
            VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                Image(systemName: systemImage)
                    .foregroundStyle(ThemeColors.accentPrimary)
                    .font(.title3)
                Text(value)
                    .font(.title2.weight(.bold))
                Text(title)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
