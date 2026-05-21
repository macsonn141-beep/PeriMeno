import SwiftData

enum PersistenceController {
    static func makeContainer(inMemory: Bool = false) -> ModelContainer {
        let schema = Schema([
            UserProfile.self,
            DailyEntry.self,
            SymptomLog.self,
            CustomSymptom.self,
            TriggerLog.self,
            CycleLog.self,
            MedicationProfile.self,
            MedicationEvent.self,
            InsightSnapshot.self,
            AppointmentPrep.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Unable to create SwiftData container: \(error)")
        }
    }
}
