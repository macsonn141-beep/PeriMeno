import Foundation

struct CorrelationEngine {
    func basicCorrelationSummary(entries: [DailyEntry]) -> String {
        let lowSleepAndBrainFog = entries.filter { $0.sleepScore <= 2 && $0.brainFogScore >= 4 }.count
        guard lowSleepAndBrainFog > 0 else {
            return String.pmLocalized( "correlation.placeholder.none")
        }
        return String.pmLocalized( "correlation.placeholder.lowSleepBrainFog") + " \(lowSleepAndBrainFog)"
    }
}
