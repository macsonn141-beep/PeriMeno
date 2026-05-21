import Foundation
import SwiftData

@Model
final class DailyEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var overallScore: Int
    var moodScore: Int
    var energyScore: Int
    var sleepScore: Int
    var brainFogScore: Int
    var notes: String
    var impactWork: Int
    var impactSleep: Int
    var impactRelationship: Int
    var impactIntimacy: Int
    var usedBrainFogMode: Bool
    var createdAt: Date
    var updatedAt: Date
    @Relationship(deleteRule: .cascade) var symptoms: [SymptomLog]
    @Relationship(deleteRule: .cascade) var triggers: [TriggerLog]
    @Relationship(deleteRule: .cascade) var medicationsTaken: [MedicationEvent]
    @Relationship(deleteRule: .cascade) var cycleLog: CycleLog?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        overallScore: Int = 3,
        moodScore: Int = 3,
        energyScore: Int = 3,
        sleepScore: Int = 3,
        brainFogScore: Int = 3,
        notes: String = "",
        impactWork: Int = 0,
        impactSleep: Int = 0,
        impactRelationship: Int = 0,
        impactIntimacy: Int = 0,
        usedBrainFogMode: Bool = false,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        symptoms: [SymptomLog] = [],
        triggers: [TriggerLog] = [],
        medicationsTaken: [MedicationEvent] = [],
        cycleLog: CycleLog? = nil
    ) {
        self.id = id
        self.date = date
        self.overallScore = overallScore
        self.moodScore = moodScore
        self.energyScore = energyScore
        self.sleepScore = sleepScore
        self.brainFogScore = brainFogScore
        self.notes = notes
        self.impactWork = impactWork
        self.impactSleep = impactSleep
        self.impactRelationship = impactRelationship
        self.impactIntimacy = impactIntimacy
        self.usedBrainFogMode = usedBrainFogMode
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.symptoms = symptoms
        self.triggers = triggers
        self.medicationsTaken = medicationsTaken
        self.cycleLog = cycleLog
    }
}
