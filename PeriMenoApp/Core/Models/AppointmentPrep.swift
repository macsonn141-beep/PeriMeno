import Foundation
import SwiftData

@Model
final class AppointmentPrep {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var dateRange: String
    var topSymptomsSummary: String
    var medicationSummary: String
    var suggestedQuestions: [String]
    var reportFileURL: String?

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        dateRange: String = "",
        topSymptomsSummary: String = "",
        medicationSummary: String = "",
        suggestedQuestions: [String] = [],
        reportFileURL: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.dateRange = dateRange
        self.topSymptomsSummary = topSymptomsSummary
        self.medicationSummary = medicationSummary
        self.suggestedQuestions = suggestedQuestions
        self.reportFileURL = reportFileURL
    }
}
