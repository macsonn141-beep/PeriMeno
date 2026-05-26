import SwiftData
import SwiftUI

@main
struct PeriMenoApp: App {
    @StateObject private var appState = AppState()
    @AppStorage("settings.languageCode") private var selectedLanguageCode = "en"
    private let modelContainer: ModelContainer

    init() {
        modelContainer = PersistenceController.makeContainer()
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(appState)
                .environment(\.locale, Locale(identifier: selectedLanguageCode))
                .environment(\.layoutDirection, selectedLanguageCode == "ar" ? .rightToLeft : .leftToRight)
                .id(selectedLanguageCode)
        }
        .modelContainer(modelContainer)
    }
}
