import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var isPremiumUnlocked = false
    @Published var faceIDEnabled = false
    @Published var hasCompletedOnboarding = false

    @Published var router = AppRouter()

    init(processInfo: ProcessInfo = .processInfo) {
        isPremiumUnlocked = UserDefaults.standard.string(forKey: "perimeno.premium.productID") != nil

        // UI tests launch into the main shell so tab navigation checks are deterministic.
        if processInfo.arguments.contains("-uiTestingSkipOnboarding") {
            hasCompletedOnboarding = true
        }
    }

    func push(_ route: AppRoute, on tab: AppTab? = nil) {
        if let tab {
            selectedTab = tab
        }

        switch tab ?? selectedTab {
        case .home:
            router.homePath.append(route)
        case .log:
            router.logPath.append(route)
        case .insights:
            router.insightsPath.append(route)
        case .reports:
            router.reportsPath.append(route)
        case .settings:
            router.settingsPath.append(route)
        }

        objectWillChange.send()
    }

    func popCurrentRoute() {
        switch selectedTab {
        case .home where !router.homePath.isEmpty:
            router.homePath.removeLast()
        case .log where !router.logPath.isEmpty:
            router.logPath.removeLast()
        case .insights where !router.insightsPath.isEmpty:
            router.insightsPath.removeLast()
        case .reports where !router.reportsPath.isEmpty:
            router.reportsPath.removeLast()
        case .settings where !router.settingsPath.isEmpty:
            router.settingsPath.removeLast()
        default:
            break
        }

        objectWillChange.send()
    }
}

enum AppTab: Hashable {
    case home
    case log
    case insights
    case reports
    case settings
}
