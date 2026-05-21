import SwiftUI

struct SettingsRow: Identifiable {
    let id: String
    let title: LocalizedStringResource
    let systemImage: String
    let route: AppRoute?
}
