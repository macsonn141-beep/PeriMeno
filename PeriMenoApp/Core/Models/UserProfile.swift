import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var preferredLanguageCode: String
    var onboardingCompleted: Bool
    var isPremiumUnlocked: Bool
    var faceIDEnabled: Bool
    var selectedTheme: String
    var timeZoneIdentifier: String
    var ageRange: String?
    var menopauseStageHint: String?

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        preferredLanguageCode: String = Locale.current.language.languageCode?.identifier ?? "en",
        onboardingCompleted: Bool = false,
        isPremiumUnlocked: Bool = false,
        faceIDEnabled: Bool = false,
        selectedTheme: String = "system",
        timeZoneIdentifier: String = TimeZone.current.identifier,
        ageRange: String? = nil,
        menopauseStageHint: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.preferredLanguageCode = preferredLanguageCode
        self.onboardingCompleted = onboardingCompleted
        self.isPremiumUnlocked = isPremiumUnlocked
        self.faceIDEnabled = faceIDEnabled
        self.selectedTheme = selectedTheme
        self.timeZoneIdentifier = timeZoneIdentifier
        self.ageRange = ageRange
        self.menopauseStageHint = menopauseStageHint
    }
}
