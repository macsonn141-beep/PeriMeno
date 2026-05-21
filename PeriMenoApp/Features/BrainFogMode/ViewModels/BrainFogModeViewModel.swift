import Foundation

@MainActor
final class BrainFogModeViewModel: ObservableObject {
    @Published var selectedFeelingID = "okay"
    @Published var selectedSymptoms: Set<String> = ["brain_fog"]
    @Published var quickNote = ""

    let choices = [
        BrainFogChoice(id: "bad", title: "brainFog.choice.bad", score: 1),
        BrainFogChoice(id: "okay", title: "brainFog.choice.okay", score: 3),
        BrainFogChoice(id: "good", title: "brainFog.choice.good", score: 5)
    ]

    func makeEntry() -> DailyEntry {
        let score = choices.first(where: { $0.id == selectedFeelingID })?.score ?? 3
        return DailyEntry(
            overallScore: score,
            moodScore: score,
            energyScore: score,
            sleepScore: score,
            brainFogScore: selectedSymptoms.contains("brain_fog") ? 5 : 3,
            notes: Validators.trimmed(quickNote),
            usedBrainFogMode: true,
            symptoms: selectedSymptoms.map { SymptomLog(symptomType: $0, severity: score) }
        )
    }

    func reset() {
        selectedFeelingID = "okay"
        selectedSymptoms = ["brain_fog"]
        quickNote = ""
    }
}
