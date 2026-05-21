import SwiftData
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]
    @Query(filter: #Predicate<MedicationProfile> { $0.isActive }) private var activeMedications: [MedicationProfile]
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ThemeSpacing.large) {
                VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                    Text("home.greeting")
                        .font(.title2.weight(.semibold))
                    Text("home.subtitle")
                        .foregroundStyle(.secondary)
                }

                PMCard {
                    VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                        PMSectionHeader(title: "home.today.title")
                        if entries.isEmpty {
                            Text("home.empty.body")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Button {
                                appState.selectedTab = .log
                            } label: {
                                Label("home.empty.logCTA", systemImage: "plus.circle")
                            }
                        } else {
                            ForEach(viewModel.latestEntryDetails(entries: entries), id: \.self) { detail in
                                Text(detail)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: ThemeSpacing.medium) {
                    ForEach(viewModel.actions) { action in
                        Button {
                            if let tab = action.tab {
                                appState.selectedTab = tab
                            }
                            if let route = action.route {
                                appState.push(route, on: .home)
                            }
                        } label: {
                            PMCard {
                                Label(action.title, systemImage: action.systemImage)
                                    .font(.headline)
                                    .frame(minHeight: 44)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                PMCard {
                    VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                        HStack {
                            PMSectionHeader(title: "home.trend.title")
                            Spacer()
                            PMPremiumBadge()
                        }
                        Text("home.trend.placeholder")
                            .foregroundStyle(.secondary)
                    }
                }

                PMCard {
                    VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                        PMSectionHeader(title: "home.medication.title")
                        Text(activeMedications.isEmpty ? "home.medication.empty" : "home.medication.active")
                            .foregroundStyle(.secondary)
                        Button {
                            appState.push(.medications, on: .home)
                        } label: {
                            Label("home.medication.open", systemImage: "pills")
                        }
                    }
                }

                PMCard {
                    VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                        PMSectionHeader(title: "home.appointment.title")
                        Text("home.appointment.body")
                            .foregroundStyle(.secondary)
                        Button {
                            appState.push(.appointmentBuilder, on: .home)
                        } label: {
                            Label("home.appointment.open", systemImage: "stethoscope")
                        }
                    }
                }

                if !appState.isPremiumUnlocked {
                    PMCard {
                        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                            HStack {
                                PMSectionHeader(title: "home.premium.title")
                                Spacer()
                                PMPremiumBadge()
                            }
                            Text("home.premium.body")
                                .foregroundStyle(.secondary)
                            Button {
                                appState.push(.paywall, on: .home)
                            } label: {
                                Label("home.premium.open", systemImage: "sparkles")
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(ThemeColors.backgroundPrimary)
        .navigationTitle("home.title")
        .accessibilityIdentifier("screen.home")
    }
}
