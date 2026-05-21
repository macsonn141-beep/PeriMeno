import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    let onComplete: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: ThemeSpacing.large) {
                    if viewModel.isShowingOverview {
                        overviewContent
                    } else {
                        stepContent(for: viewModel.currentPage)
                    }
                }
                .padding()
                .padding(.bottom, ThemeSpacing.xLarge)
            }
            .background(ThemeColors.backgroundPrimary)
            .safeAreaInset(edge: .bottom) {
                bottomAction
            }
            .navigationTitle("onboarding.navTitle")
        }
    }

    @ViewBuilder
    private var overviewContent: some View {
        Text("onboarding.title")
            .font(.largeTitle.weight(.bold))

        Text("onboarding.subtitle")
            .font(.body)
            .foregroundStyle(.secondary)

        ForEach(viewModel.pages) { page in
            PMCard {
                Label {
                    VStack(alignment: .leading, spacing: ThemeSpacing.xSmall) {
                        Text(page.title)
                            .font(.headline)
                        Text(page.detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: page.systemImage)
                        .foregroundStyle(ThemeColors.accentPrimary)
                }
            }
        }
    }

    private func stepContent(for page: OnboardingPage) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.large) {
            Image(systemName: page.systemImage)
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(ThemeColors.accentPrimary)
                .frame(width: 72, height: 72)
                .background(ThemeColors.cardBackground, in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                Text(page.title)
                    .font(.largeTitle.weight(.bold))
                    .accessibilityIdentifier("onboarding.step.title")

                Text(page.detail)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            PMCard {
                Label {
                    VStack(alignment: .leading, spacing: ThemeSpacing.xSmall) {
                        Text(page.title)
                            .font(.headline)
                        Text(page.detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: page.systemImage)
                        .foregroundStyle(ThemeColors.accentPrimary)
                }
            }
        }
    }

    private var bottomAction: some View {
        VStack(spacing: ThemeSpacing.small) {
            PMButton(title: "onboarding.continue", systemImage: "arrow.right") {
                let tappedIndex = viewModel.currentPageIndex
                print("Onboarding CTA tapped at step \(tappedIndex)")

                var shouldComplete = false
                withAnimation(.easeInOut) {
                    shouldComplete = viewModel.advance()
                }

                if shouldComplete {
                    onComplete()
                }
            }
            .accessibilityIdentifier("onboarding.continue.button")
        }
        .padding(.horizontal)
        .padding(.top, ThemeSpacing.small)
        .padding(.bottom, ThemeSpacing.small)
        .background(.ultraThinMaterial)
    }
}
