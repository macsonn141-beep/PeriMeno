import Foundation

struct LogDraft {
    var selectedSymptomIDs: Set<String> = ["hot_flashes"]
    var selectedTriggerIDs: Set<String> = []
    var overallScore = 3
    var moodScore = 3
    var energyScore = 3
    var sleepScore = 3
    var brainFogScore = 3
    var impactWork = 0
    var impactSleep = 0
    var impactRelationship = 0
    var impactIntimacy = 0
    var bleedingType = "none"
    var flowLevel = 0
    var crampLevel = 0
    var cycleNote = ""
    var tookMedication = false
    var selectedMedicationProfileID: UUID?
    var notes = ""
}

extension LogDraft {
    init(entry: DailyEntry) {
        selectedSymptomIDs = Set(entry.symptoms.map(\.symptomType))
        selectedTriggerIDs = Set(entry.triggers.map(\.triggerType))
        overallScore = entry.overallScore
        moodScore = entry.moodScore
        energyScore = entry.energyScore
        sleepScore = entry.sleepScore
        brainFogScore = entry.brainFogScore
        impactWork = entry.impactWork
        impactSleep = entry.impactSleep
        impactRelationship = entry.impactRelationship
        impactIntimacy = entry.impactIntimacy
        bleedingType = entry.cycleLog?.bleedingType ?? "none"
        flowLevel = entry.cycleLog?.flowLevel ?? 0
        crampLevel = entry.cycleLog?.crampLevel ?? 0
        cycleNote = entry.cycleLog?.note ?? ""
        tookMedication = !entry.medicationsTaken.isEmpty
        selectedMedicationProfileID = entry.medicationsTaken.first?.medicationProfileID
        notes = entry.notes
    }
}
