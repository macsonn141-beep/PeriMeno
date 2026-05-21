import Foundation
import SwiftData

@Model
final class MedicationEvent {
    @Attribute(.unique) var id: UUID
    var medicationProfileID: UUID
    var takenAt: Date
    var adherence: Bool
    var perceivedEffectScore: Int?
    var sideEffectNote: String

    init(
        id: UUID = UUID(),
        medicationProfileID: UUID,
        takenAt: Date = .now,
        adherence: Bool = true,
        perceivedEffectScore: Int? = nil,
        sideEffectNote: String = ""
    ) {
        self.id = id
        self.medicationProfileID = medicationProfileID
        self.takenAt = takenAt
        self.adherence = adherence
        self.perceivedEffectScore = perceivedEffectScore
        self.sideEffectNote = sideEffectNote
    }
}
