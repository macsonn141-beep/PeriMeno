import Foundation

@MainActor
final class MedicationLogViewModel: ObservableObject {
    @Published var draft = MedicationDraft()
    let categories = ["HRT", "supplement", "prescription", "OTC", "other"]

    func makeProfile() -> MedicationProfile {
        MedicationProfile(
            name: Validators.trimmed(draft.name),
            category: draft.category,
            dose: Validators.trimmed(draft.dose),
            frequency: Validators.trimmed(draft.frequency)
        )
    }

    func makeEvent(for profile: MedicationProfile) -> MedicationEvent {
        MedicationEvent(
            medicationProfileID: profile.id,
            adherence: true,
            perceivedEffectScore: draft.perceivedEffectScore,
            sideEffectNote: Validators.trimmed(draft.sideEffectNote)
        )
    }

    func resetProfileFields() {
        draft.name = ""
        draft.dose = ""
        draft.frequency = ""
    }
}
