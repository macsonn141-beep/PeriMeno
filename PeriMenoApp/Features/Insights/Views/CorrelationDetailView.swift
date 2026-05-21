import SwiftData
import SwiftUI

struct CorrelationDetailView: View {
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]
    private let engine = CorrelationEngine()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ThemeSpacing.large) {
                PMCard {
                    VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                        PMSectionHeader(title: "correlation.title")
                        Text(engine.basicCorrelationSummary(entries: entries))
                            .foregroundStyle(.secondary)
                    }
                }
                PMCard {
                    Text("correlation.disclaimer")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .background(ThemeColors.backgroundPrimary)
        .navigationTitle("correlation.navTitle")
    }
}
