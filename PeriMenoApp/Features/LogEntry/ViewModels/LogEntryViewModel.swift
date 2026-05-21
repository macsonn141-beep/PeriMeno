import Foundation

@MainActor
final class LogEntryViewModel: ObservableObject {
    @Published var draft = LogDraft()
    @Published var didSave = false

    func makeEntry() -> DailyEntry {
        let cycleLog = makeCycleLogIfNeeded()
        let medicationsTaken = makeMedicationEventsIfNeeded()

        return DailyEntry(
            overallScore: draft.overallScore,
            moodScore: draft.moodScore,
            energyScore: draft.energyScore,
            sleepScore: draft.sleepScore,
            brainFogScore: draft.brainFogScore,
            notes: Validators.trimmed(draft.notes),
            impactWork: draft.impactWork,
            impactSleep: draft.impactSleep,
            impactRelationship: draft.impactRelationship,
            impactIntimacy: draft.impactIntimacy,
            symptoms: draft.selectedSymptomIDs.map { SymptomLog(symptomType: $0, severity: draft.overallScore) },
            triggers: draft.selectedTriggerIDs.map { TriggerLog(triggerType: $0, intensity: draft.overallScore) },
            medicationsTaken: medicationsTaken,
            cycleLog: cycleLog
        )
    }

    func reset() {
        draft = LogDraft()
        didSave = true
    }

    private func makeCycleLogIfNeeded() -> CycleLog? {
        guard draft.bleedingType != "none" || draft.flowLevel > 0 || draft.crampLevel > 0 || !Validators.trimmed(draft.cycleNote).isEmpty else {
            return nil
        }

        return CycleLog(
            bleedingType: draft.bleedingType,
            flowLevel: draft.flowLevel,
            crampLevel: draft.crampLevel,
            note: Validators.trimmed(draft.cycleNote)
        )
    }

    private func makeMedicationEventsIfNeeded() -> [MedicationEvent] {
        guard draft.tookMedication, let selectedMedicationProfileID = draft.selectedMedicationProfileID else {
            return []
        }

        return [
            MedicationEvent(
                medicationProfileID: selectedMedicationProfileID,
                adherence: true
            )
        ]
    }
}
