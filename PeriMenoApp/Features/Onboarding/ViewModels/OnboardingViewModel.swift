import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var currentPageIndex = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(id: "welcome", title: "onboarding.welcome.title", detail: "onboarding.welcome.detail", systemImage: "heart.text.square"),
        OnboardingPage(id: "track", title: "onboarding.track.title", detail: "onboarding.track.detail", systemImage: "checklist"),
        OnboardingPage(id: "brainFog", title: "onboarding.brainFog.title", detail: "onboarding.brainFog.detail", systemImage: "brain.head.profile"),
        OnboardingPage(id: "reports", title: "onboarding.reports.title", detail: "onboarding.reports.detail", systemImage: "doc.text"),
        OnboardingPage(id: "privacy", title: "onboarding.privacy.title", detail: "onboarding.privacy.detail", systemImage: "lock.shield"),
        OnboardingPage(id: "baseline", title: "onboarding.baseline.title", detail: "onboarding.baseline.detail", systemImage: "person.text.rectangle"),
        OnboardingPage(id: "notifications", title: "onboarding.notifications.title", detail: "onboarding.notifications.detail", systemImage: "bell.badge"),
        OnboardingPage(id: "premium", title: "onboarding.premium.title", detail: "onboarding.premium.detail", systemImage: "sparkles")
    ]

    var isShowingOverview: Bool {
        currentPageIndex == 0
    }

    var currentPage: OnboardingPage {
        pages[min(currentPageIndex, pages.count - 1)]
    }

    func advance() -> Bool {
        guard currentPageIndex < pages.count - 1 else {
            return true
        }

        currentPageIndex += 1
        return false
    }
}
