import Foundation
import SwiftData

@Model
final class InsightSnapshot {
    @Attribute(.unique) var id: UUID
    var generatedAt: Date
    var summaryType: String
    var title: String
    var body: String
    var score: Double?

    init(
        id: UUID = UUID(),
        generatedAt: Date = .now,
        summaryType: String,
        title: String,
        body: String,
        score: Double? = nil
    ) {
        self.id = id
        self.generatedAt = generatedAt
        self.summaryType = summaryType
        self.title = title
        self.body = body
        self.score = score
    }
}
