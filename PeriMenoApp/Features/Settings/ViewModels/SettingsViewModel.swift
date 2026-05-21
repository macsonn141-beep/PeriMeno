import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var faceIDEnabled = false
    @Published var notificationsEnabled = false
    @Published var selectedLanguageCode = "en"

    let rows = [
        SettingsRow(id: "privacy", title: "settings.privacySecurity", systemImage: "lock.shield", route: .privacySecurity),
        SettingsRow(id: "health", title: "settings.healthAccess", systemImage: "heart.text.square", route: .healthAccess),
        SettingsRow(id: "premium", title: "settings.premium", systemImage: "sparkles", route: .paywall),
        SettingsRow(id: "exportBackup", title: "settings.exportBackup", systemImage: "externaldrive", route: nil),
        SettingsRow(id: "legal", title: "settings.legal", systemImage: "doc.text", route: nil)
    ]
}
