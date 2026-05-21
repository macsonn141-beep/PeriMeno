import Foundation
import SwiftData

@Model
final class TriggerLog {
    @Attribute(.unique) var id: UUID
    var triggerType: String
    var intensity: Int?
    var note: String

    init(
        id: UUID = UUID(),
        triggerType: String,
        intensity: Int? = nil,
        note: String = ""
    ) {
        self.id = id
        self.triggerType = triggerType
        self.intensity = intensity
        self.note = note
    }
}
