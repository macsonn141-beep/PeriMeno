import SwiftData
import SwiftUI

struct InsightsOverviewView: View {
    @EnvironmentObject private var appState: AppState
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]
    @StateObject private var viewModel = InsightsOverviewViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ThemeSpacing.large) {
                if entries.isEmpty {
                    PMEmptyStateView(
                        title: "insights.empty.title",
                        message: "insights.empty.message",
                        systemImage: "chart.xyaxis.line"
                    )
                } else {
                    ForEach(viewModel.cards(for: entries)) { card in
                        PMCard {
                            VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                                HStack {
                                    Label {
                                        Text(card.title)
                                            .font(.headline)
                                    } icon: {
                                        Image(systemName: card.systemImage)
                                    }
                                    Spacer()
                                    if card.isPremium {
                                        PMPremiumBadge()
                                    }
                                }
                                Text(card.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                NavigationLink(value: AppRoute.trendDetail) {
                    Label {
                        Text("insights.trend.open")
                            .frame(maxWidth: .infinity)
                    } icon: {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                    }
                    .font(.headline)
                    .padding(.vertical, ThemeSpacing.small)
                }
                .buttonStyle(.borderedProminent)
                .tint(ThemeColors.accentSecondary)
                .pmMinimumTapTarget()

                NavigationLink(value: AppRoute.correlationDetail) {
                    Label {
                        Text("insights.correlation.open")
                            .frame(maxWidth: .infinity)
                    } icon: {
                        Image(systemName: "point.3.connected.trianglepath.dotted")
                    }
                    .font(.headline)
                    .padding(.vertical, ThemeSpacing.small)
                }
                .buttonStyle(.borderedProminent)
                .tint(ThemeColors.accentSecondary)
                .pmMinimumTapTarget()
            }
            .padding()
        }
        .background(ThemeColors.backgroundPrimary)
        .navigationTitle("insights.title")
        .accessibilityIdentifier("screen.insights")
    }
}
