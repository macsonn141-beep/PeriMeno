import Foundation
import SwiftData

@Model
final class SymptomLog {
    @Attribute(.unique) var id: UUID
    var symptomType: String
    var severity: Int
    var durationMinutes: Int?
    var timeOfDay: String?
    var note: String
    var isCustom: Bool

    init(
        id: UUID = UUID(),
        symptomType: String,
        severity: Int = 3,
        durationMinutes: Int? = nil,
        timeOfDay: String? = nil,
        note: String = "",
        isCustom: Bool = false
    ) {
        self.id = id
        self.symptomType = symptomType
        self.severity = severity
        self.durationMinutes = durationMinutes
        self.timeOfDay = timeOfDay
        self.note = note
        self.isCustom = isCustom
    }
}
