import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack(path: $appState.router.homePath) {
                HomeView()
                    .navigationDestination(for: AppRoute.self, destination: destination)
            }
            .tabItem {
                Label("tab.home", systemImage: "house")
            }
            .tag(AppTab.home)
            .accessibilityIdentifier("tab.home")

            NavigationStack(path: $appState.router.logPath) {
                LogEntryView()
                    .navigationDestination(for: AppRoute.self, destination: destination)
            }
            .tabItem {
                Label("tab.log", systemImage: "plus.circle")
            }
            .tag(AppTab.log)
            .accessibilityIdentifier("tab.log")

            NavigationStack(path: $appState.router.insightsPath) {
                InsightsOverviewView()
                    .navigationDestination(for: AppRoute.self, destination: destination)
            }
            .tabItem {
                Label("tab.insights", systemImage: "chart.xyaxis.line")
            }
            .tag(AppTab.insights)
            .accessibilityIdentifier("tab.insights")

            NavigationStack(path: $appState.router.reportsPath) {
                ReportsExportView()
                    .navigationDestination(for: AppRoute.self, destination: destination)
            }
            .tabItem {
                Label("tab.reports", systemImage: "doc.text")
            }
            .tag(AppTab.reports)
            .accessibilityIdentifier("tab.reports")

            NavigationStack(path: $appState.router.settingsPath) {
                SettingsView()
                    .navigationDestination(for: AppRoute.self, destination: destination)
            }
            .tabItem {
                Label("tab.settings", systemImage: "gearshape")
            }
            .tag(AppTab.settings)
            .accessibilityIdentifier("tab.settings")
        }
        .tint(ThemeColors.accentPrimary)
        .sheet(isPresented: .constant(!appState.hasCompletedOnboarding)) {
            OnboardingView {
                appState.hasCompletedOnboarding = true
            }
            .interactiveDismissDisabled()
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .paywall:
            PaywallView()
        case .entryHistory:
            EntryHistoryView()
        case .brainFogMode:
            BrainFogModeView()
        case .symptomsPicker:
            SymptomsPickerView()
        case .cycleLog:
            CycleLogView()
        case .medications:
            MedicationLogView()
        case .trendDetail:
            TrendDetailView()
        case .correlationDetail:
            CorrelationDetailView()
        case .appointmentBuilder:
            AppointmentBuilderView()
        case .privacySecurity:
            PrivacySecurityView()
        case .healthAccess:
            HealthAccessView()
        }
    }
}
