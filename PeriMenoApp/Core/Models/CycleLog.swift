import Foundation
import SwiftData

@Model
final class CycleLog {
    @Attribute(.unique) var id: UUID
    var date: Date
    var bleedingType: String
    var flowLevel: Int
    var crampLevel: Int
    var note: String

    init(
        id: UUID = UUID(),
        date: Date = .now,
        bleedingType: String = "none",
        flowLevel: Int = 0,
        crampLevel: Int = 0,
        note: String = ""
    ) {
        self.id = id
        self.date = date
        self.bleedingType = bleedingType
        self.flowLevel = flowLevel
        self.crampLevel = crampLevel
        self.note = note
    }
}
