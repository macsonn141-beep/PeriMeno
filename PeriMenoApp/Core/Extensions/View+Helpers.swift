import SwiftUI

extension View {
    func pmCardStyle() -> some View {
        self
            .padding(ThemeSpacing.medium)
            .background(ThemeColors.cardBackground, in: RoundedRectangle(cornerRadius: Theme.radiusMedium))
    }

    func pmMinimumTapTarget() -> some View {
        self.frame(minHeight: 44)
    }
}
