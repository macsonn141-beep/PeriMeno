import Charts
import SwiftData
import SwiftUI

struct TrendDetailView: View {
    @Query(sort: \DailyEntry.date) private var entries: [DailyEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.large) {
            Text("trend.detail.body")
                .foregroundStyle(.secondary)

            Chart(entries) { entry in
                LineMark(
                    x: .value("trend.chart.date", entry.date),
                    y: .value("trend.chart.score", entry.overallScore)
                )
            }
            .frame(height: 220)
            .pmCardStyle()

            Spacer()
        }
        .padding()
        .background(ThemeColors.backgroundPrimary)
        .navigationTitle("trend.title")
    }
}
