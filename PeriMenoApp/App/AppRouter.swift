import Foundation

@MainActor
final class AppRouter: ObservableObject {
    @Published var homePath: [AppRoute] = []
    @Published var logPath: [AppRoute] = []
    @Published var insightsPath: [AppRoute] = []
    @Published var reportsPath: [AppRoute] = []
    @Published var settingsPath: [AppRoute] = []
}

enum AppRoute: Hashable {
    case paywall
    case entryHistory
    case brainFogMode
    case symptomsPicker
    case cycleLog
    case medications
    case trendDetail
    case correlationDetail
    case appointmentBuilder
    case privacySecurity
    case healthAccess
}
