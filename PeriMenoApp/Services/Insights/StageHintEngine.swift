import Foundation

struct StageHintEngine {
    func stageHint(for profile: UserProfile?) -> String {
        guard let hint = profile?.menopauseStageHint, !hint.isEmpty else {
            return String.pmLocalized( "stageHint.placeholder")
        }
        return hint
    }
}
