import SwiftUI

struct PMSymptomChip: View {
    let title: LocalizedStringResource
    let systemImage: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: ThemeSpacing.small) {
            Image(systemName: systemImage)
            Text(title)
        }
        .font(.callout.weight(.medium))
        .padding(.horizontal, ThemeSpacing.medium)
        .padding(.vertical, ThemeSpacing.small)
        .frame(minHeight: 44)
        .background(isSelected ? ThemeColors.accentPrimary.opacity(0.16) : ThemeColors.backgroundSecondary, in: Capsule())
        .foregroundStyle(isSelected ? ThemeColors.accentPrimary : ThemeColors.textPrimary)
    }
}
