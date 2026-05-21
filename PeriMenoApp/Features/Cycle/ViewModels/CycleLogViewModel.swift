import Foundation

@MainActor
final class CycleLogViewModel: ObservableObject {
    @Published var draft = CycleDraft()

    let bleedingTypes = ["none", "spotting", "light", "moderate", "heavy"]

    func makeCycleLog() -> CycleLog {
        CycleLog(
            bleedingType: draft.bleedingType,
            flowLevel: draft.flowLevel,
            crampLevel: draft.crampLevel,
            note: Validators.trimmed(draft.note)
        )
    }
}
