import Foundation

@MainActor
final class InsightsOverviewViewModel: ObservableObject {
    private let insightEngine = InsightEngine()
    private let correlationEngine = CorrelationEngine()

    func cards(for entries: [DailyEntry]) -> [InsightCardModel] {
        let snapshots = insightEngine.makeOverviewSnapshots(from: entries)
        let baseCards = snapshots.enumerated().map { index, snapshot in
            InsightCardModel(
                id: snapshot.summaryType + "\(index)",
                title: snapshot.title,
                body: snapshot.body,
                systemImage: "sparkles",
                isPremium: false
            )
        }

        let correlation = InsightCardModel(
            id: "correlation",
            title: String(localized: "insights.correlation.title"),
            body: correlationEngine.basicCorrelationSummary(entries: entries),
            systemImage: "point.3.connected.trianglepath.dotted",
            isPremium: true
        )

        return baseCards + [correlation]
    }
}
