import Foundation
import SwiftUI

struct SupportedLanguage: Identifiable {
    let id: String
    let name: LocalizedStringResource
}

@MainActor
final class LocalizationManager: ObservableObject {
    @Published var selectedLanguageCode: String = Locale.current.language.languageCode?.identifier ?? "en"

    let supportedLanguages = [
        SupportedLanguage(id: "en", name: "language.english"),
        SupportedLanguage(id: "es", name: "language.spanish"),
        SupportedLanguage(id: "pt-BR", name: "language.portugueseBrazil"),
        SupportedLanguage(id: "fr", name: "language.french"),
        SupportedLanguage(id: "de", name: "language.german"),
        SupportedLanguage(id: "it", name: "language.italian"),
        SupportedLanguage(id: "ja", name: "language.japanese"),
        SupportedLanguage(id: "ko", name: "language.korean"),
        SupportedLanguage(id: "zh-Hans", name: "language.chineseSimplified"),
        SupportedLanguage(id: "zh-Hant", name: "language.chineseTraditional"),
        SupportedLanguage(id: "ar", name: "language.arabic"),
        SupportedLanguage(id: "hi", name: "language.hindi"),
        SupportedLanguage(id: "id", name: "language.indonesian"),
        SupportedLanguage(id: "tr", name: "language.turkish"),
        SupportedLanguage(id: "th", name: "language.thai")
    ]

    var supportedLanguageCodes: [String] {
        supportedLanguages.map(\.id)
    }
}
