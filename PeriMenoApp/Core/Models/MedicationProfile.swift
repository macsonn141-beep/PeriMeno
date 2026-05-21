import Foundation
import SwiftData

@Model
final class MedicationProfile {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    var dose: String
    var frequency: String
    var startDate: Date?
    var endDate: Date?
    var note: String
    var isActive: Bool

    init(
        id: UUID = UUID(),
        name: String,
        category: String = "other",
        dose: String = "",
        frequency: String = "",
        startDate: Date? = nil,
        endDate: Date? = nil,
        note: String = "",
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.dose = dose
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.note = note
        self.isActive = isActive
    }
}
