import Foundation

struct CorrelationEngine {
    func basicCorrelationSummary(entries: [DailyEntry]) -> String {
        let lowSleepAndBrainFog = entries.filter { $0.sleepScore <= 2 && $0.brainFogScore >= 4 }.count
        guard lowSleepAndBrainFog > 0 else {
            return String(localized: "correlation.placeholder.none")
        }
        return String(localized: "correlation.placeholder.lowSleepBrainFog") + " \(lowSleepAndBrainFog)"
    }
}
