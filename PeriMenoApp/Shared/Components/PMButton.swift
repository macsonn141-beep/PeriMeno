import SwiftUI

struct PMButton: View {
    let title: LocalizedStringResource
    let systemImage: String?
    var style: Style = .primary
    let action: () -> Void

    enum Style {
        case primary
        case secondary
    }

    var body: some View {
        Button(action: action) {
            Label {
                Text(title)
                    .frame(maxWidth: .infinity)
            } icon: {
                if let systemImage {
                    Image(systemName: systemImage)
                }
            }
            .font(.headline)
            .padding(.vertical, ThemeSpacing.small)
        }
        .buttonStyle(.borderedProminent)
        .tint(style == .primary ? ThemeColors.accentPrimary : ThemeColors.accentSecondary)
        .pmMinimumTapTarget()
    }
}
