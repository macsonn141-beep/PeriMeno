import Foundation

struct InsightEngine {
    func makeOverviewSnapshots(from entries: [DailyEntry]) -> [InsightSnapshot] {
        guard !entries.isEmpty else {
            return [
                InsightSnapshot(
                    summaryType: "empty",
                    title: String.pmLocalized( "insights.empty.title"),
                    body: String.pmLocalized( "insights.empty.message")
                )
            ]
        }

        let calendar = Calendar.current
        let now = Date.now
        let last7Days = entries.filter { entry in
            guard let days = calendar.dateComponents([.day], from: entry.date, to: now).day else {
                return false
            }
            return days >= 0 && days < 7
        }
        let last30Days = entries.filter { entry in
            guard let days = calendar.dateComponents([.day], from: entry.date, to: now).day else {
                return false
            }
            return days >= 0 && days < 30
        }

        var snapshots = [
            InsightSnapshot(
                summaryType: "entries_last_7_days",
                title: String.pmLocalized( "insights.entries7.title"),
                body: String.pmLocalized( "insights.entries7.body") + " \(last7Days.count)",
                score: Double(last7Days.count)
            )
        ]

        if let topSymptom = mostFrequentSymptom(in: last30Days) {
            snapshots.append(
                InsightSnapshot(
                    summaryType: "top_symptom_30_days",
                    title: String.pmLocalized( "insights.topSymptom.title"),
                    body: String.pmLocalized( "insights.topSymptom.body") + " \(displayName(for: topSymptom.symptomType)) (\(topSymptom.count))",
                    score: Double(topSymptom.count)
                )
            )
        } else {
            snapshots.append(
                InsightSnapshot(
                    summaryType: "top_symptom_low_data",
                    title: String.pmLocalized( "insights.lowData.title"),
                    body: String.pmLocalized( "insights.lowData.symptoms")
                )
            )
        }

        if entries.count >= 2 {
            snapshots.append(
                InsightSnapshot(
                    summaryType: "average_scores",
                    title: String.pmLocalized( "insights.averages.title"),
                    body: averageScoreSummary(entries: entries)
                )
            )
        } else {
            snapshots.append(
                InsightSnapshot(
                    summaryType: "average_scores_low_data",
                    title: String.pmLocalized( "insights.lowData.title"),
                    body: String.pmLocalized( "insights.lowData.averages")
                )
            )
        }

        let brainFogEntries = entries.filter { $0.brainFogScore >= 4 || $0.usedBrainFogMode }.count
        snapshots.append(
            InsightSnapshot(
                summaryType: "brain_fog_frequency",
                title: String.pmLocalized( "insights.brainFog.title"),
                body: String.pmLocalized( "insights.brainFog.body") + " \(brainFogEntries)",
                score: Double(brainFogEntries)
            )
        )

        snapshots.append(
            InsightSnapshot(
                summaryType: "cautious_language",
                title: String.pmLocalized( "insights.caution.title"),
                body: String.pmLocalized( "insights.caution.body")
            )
        )

        return snapshots
    }

    private func mostFrequentSymptom(in entries: [DailyEntry]) -> (symptomType: String, count: Int)? {
        let counts = entries
            .flatMap(\.symptoms)
            .reduce(into: [String: Int]()) { partialResult, symptom in
                partialResult[symptom.symptomType, default: 0] += 1
            }

        return counts
            .max { lhs, rhs in lhs.value < rhs.value }
            .map { (symptomType: $0.key, count: $0.value) }
    }

    private func averageScoreSummary(entries: [DailyEntry]) -> String {
        let mood = average(entries.map(\.moodScore))
        let sleep = average(entries.map(\.sleepScore))
        let energy = average(entries.map(\.energyScore))
        let moodLabel = String.pmLocalized("home.latest.mood").lowercased()
        let sleepLabel = String.pmLocalized("home.latest.sleep").lowercased()
        let energyLabel = String.pmLocalized("home.latest.energy").lowercased()
        return String.pmLocalized("insights.averages.body") + " \(moodLabel) \(mood), \(sleepLabel) \(sleep), \(energyLabel) \(energy)."
    }

    private func average(_ values: [Int]) -> String {
        guard !values.isEmpty else { return "-" }
        let value = Double(values.reduce(0, +)) / Double(values.count)
        return String(format: "%.1f", value)
    }

    private func displayName(for symptomType: String) -> String {
        String.pmLocalizedKey("symptom.\(symptomType)")
    }
}
