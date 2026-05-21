import SwiftUI

struct PMSectionHeader: View {
    let title: LocalizedStringResource

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(ThemeColors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }
}
