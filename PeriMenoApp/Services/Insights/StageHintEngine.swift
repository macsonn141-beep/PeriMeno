import Foundation

struct StageHintEngine {
    func stageHint(for profile: UserProfile?) -> String {
        guard let hint = profile?.menopauseStageHint, !hint.isEmpty else {
            return String(localized: "stageHint.placeholder")
        }
        return hint
    }
}
