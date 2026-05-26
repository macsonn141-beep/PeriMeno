import SwiftData
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]
    @Query(filter: #Predicate<MedicationProfile> { $0.isActive }) private var activeMedications: [MedicationProfile]
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var localizationManager = LocalizationManager()
    @AppStorage("settings.languageCode") private var selectedLanguageCode = "en"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ThemeSpacing.large) {
                header

                todaySummaryCard

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
                            HomeActionTile(action: action)
                        }
                        .buttonStyle(.plain)
                    }
                }

                HomeInfoCard(tint: ThemeColors.accentSecondary, systemImage: "chart.line.uptrend.xyaxis") {
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

                HomeInfoCard(tint: ThemeColors.success, systemImage: "pills") {
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

                HomeInfoCard(tint: ThemeColors.accentPrimary, systemImage: "stethoscope") {
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
                    HomeInfoCard(tint: ThemeColors.premium, systemImage: "sparkles") {
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
        .background(homeBackground)
        .navigationTitle("home.hero.eyebrow")
        .navigationBarTitleDisplayMode(.large)
        .accessibilityIdentifier("screen.home")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            HStack(alignment: .center) {
                Text("home.title")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(ThemeColors.accentPrimary)
                    .textCase(.uppercase)

                Spacer()

                compactLanguageMenu
            }

            Text("home.hero.title")
                .font(.title.weight(.bold))
                .foregroundStyle(ThemeColors.textPrimary)

            Text("home.hero.body")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: ThemeSpacing.small) {
                HomeHeroPill(title: "home.hero.pill.private", systemImage: "lock.shield")
                HomeHeroPill(title: "home.hero.pill.symptoms", systemImage: "heart.text.square")
            }
            .padding(.top, ThemeSpacing.xSmall)

            Button {
                appState.push(.paywall, on: .home)
            } label: {
                Label("home.subscribe.button", systemImage: "sparkles")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(ThemeColors.accentPrimary)
            .padding(.top, ThemeSpacing.small)

            if appState.isPremiumUnlocked {
                Label("home.subscribe.active", systemImage: "checkmark.seal.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(ThemeColors.success)
                    .padding(.top, ThemeSpacing.xSmall)
            }
        }
        .padding(.top, ThemeSpacing.small)
    }

    private var todaySummaryCard: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                    PMSectionHeader(title: "home.today.title")
                    if entries.isEmpty {
                        Text("home.empty.body")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.latestEntryDetails(entries: entries, locale: currentLocale), id: \.self) { detail in
                            Text(detail)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Spacer(minLength: ThemeSpacing.medium)

                Image(systemName: entries.isEmpty ? "plus.circle.fill" : "heart.text.square.fill")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(ThemeColors.accentPrimary)
                    .padding(10)
                    .background(ThemeColors.accentPrimary.opacity(0.12), in: Circle())
            }

            if entries.isEmpty {
                Button {
                    appState.selectedTab = .log
                } label: {
                    Label("home.empty.logCTA", systemImage: "plus.circle")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(ThemeColors.accentPrimary)
            }
        }
        .padding(ThemeSpacing.large)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [
                            ThemeColors.cardBackground,
                            ThemeColors.accentPrimary.opacity(0.08),
                            ThemeColors.accentSecondary.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(ThemeColors.accentPrimary.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: ThemeColors.accentPrimary.opacity(0.10), radius: 16, x: 0, y: 8)
    }

    private var compactLanguageMenu: some View {
        Menu {
            ForEach(localizationManager.supportedLanguages) { language in
                Button {
                    localizationManager.selectedLanguageCode = language.id
                    selectedLanguageCode = language.id
                    UserDefaults.standard.set(language.id, forKey: "settings.languageCode")
                } label: {
                    if selectedLanguageCode == language.id {
                        Label(language.name, systemImage: "checkmark")
                    } else {
                        Text(language.name)
                    }
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "globe")
                Text(currentLanguageShortCode)
                    .font(.caption.weight(.semibold))
                Image(systemName: "chevron.down")
                    .font(.caption2.weight(.bold))
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(ThemeColors.accentSecondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(ThemeColors.accentSecondary.opacity(0.10), in: Capsule())
        }
        .accessibilityLabel(Text("settings.language"))
    }

    private var currentLanguageShortCode: String {
        switch selectedLanguageCode {
        case "pt-BR":
            return "PT"
        case "zh-Hans":
            return "简"
        case "zh-Hant":
            return "繁"
        default:
            return selectedLanguageCode.prefix(2).uppercased()
        }
    }

    private var currentLocale: Locale {
        Locale(identifier: selectedLanguageCode)
    }

    private var homeBackground: some View {
        LinearGradient(
            colors: [
                ThemeColors.accentPrimary.opacity(0.10),
                ThemeColors.backgroundPrimary,
                ThemeColors.accentSecondary.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

private struct HomeActionTile: View {
    let action: HomeAction

    var body: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            Image(systemName: action.systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 36, height: 36)
                .background(tint.opacity(0.14), in: Circle())

            Text(action.title)
                .font(.headline)
                .foregroundStyle(ThemeColors.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(ThemeSpacing.medium)
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
        .background(ThemeColors.cardBackground, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(tint.opacity(0.16), lineWidth: 1)
        )
        .shadow(color: tint.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    private var tint: Color {
        switch action.id {
        case "log":
            ThemeColors.accentPrimary
        case "brainFog":
            ThemeColors.accentSecondary
        case "history":
            ThemeColors.warning
        case "medications":
            ThemeColors.success
        case "reports":
            ThemeColors.premium
        default:
            ThemeColors.accentPrimary
        }
    }
}

private struct HomeHeroPill: View {
    let title: LocalizedStringResource
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption.weight(.semibold))
            .foregroundStyle(ThemeColors.accentSecondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(ThemeColors.accentSecondary.opacity(0.10), in: Capsule())
            .lineLimit(1)
            .minimumScaleFactor(0.82)
    }
}

private struct HomeInfoCard<Content: View>: View {
    let tint: Color
    let systemImage: String
    let content: Content

    init(tint: Color, systemImage: String, @ViewBuilder content: () -> Content) {
        self.tint = tint
        self.systemImage = systemImage
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: ThemeSpacing.medium) {
            Image(systemName: systemImage)
                .font(.headline.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 34, height: 34)
                .background(tint.opacity(0.14), in: Circle())

            content
        }
        .padding(ThemeSpacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ThemeColors.cardBackground, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(tint.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: tint.opacity(0.07), radius: 10, x: 0, y: 5)
    }
}
