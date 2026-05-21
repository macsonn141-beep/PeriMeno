import Foundation
import SwiftData

@Model
final class CustomSymptom {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    var iconName: String
    var createdAt: Date
    var isArchived: Bool

    init(
        id: UUID = UUID(),
        name: String,
        category: String = "custom",
        iconName: String = "star",
        createdAt: Date = .now,
        isArchived: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.iconName = iconName
        self.createdAt = createdAt
        self.isArchived = isArchived
    }
}
