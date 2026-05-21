import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    let actions: [HomeAction] = [
        HomeAction(id: "log", title: "home.action.log", systemImage: "plus.circle", route: nil, tab: .log),
        HomeAction(id: "brainFog", title: "home.action.brainFog", systemImage: "brain.head.profile", route: .brainFogMode, tab: nil),
        HomeAction(id: "history", title: "home.action.history", systemImage: "clock.arrow.circlepath", route: .entryHistory, tab: nil),
        HomeAction(id: "medications", title: "home.action.medications", systemImage: "pills", route: .medications, tab: nil),
        HomeAction(id: "reports", title: "home.action.reports", systemImage: "doc.text", route: nil, tab: .reports)
    ]

    func recentSummary(entries: [DailyEntry]) -> String {
        guard let latest = entries.sorted(by: { $0.date > $1.date }).first else {
            return String(localized: "home.summary.empty")
        }
        return String(localized: "home.summary.latest") + " \(latest.symptoms.count)"
    }

    func latestEntryDetails(entries: [DailyEntry]) -> [String] {
        guard let latest = entries.sorted(by: { $0.date > $1.date }).first else {
            return []
        }

        var details = [
            String(localized: "home.latest.date") + " \(latest.date.pmShortDate)",
            "Mood \(latest.moodScore)/5 · Sleep \(latest.sleepScore)/5 · Energy \(latest.energyScore)/5"
        ]

        if let topSymptom = latest.symptoms.first {
            details.append(String(localized: "home.latest.topSymptom") + " " + displayName(for: topSymptom.symptomType))
        } else {
            details.append(String(localized: "home.latest.noSymptoms"))
        }

        if !latest.notes.isEmpty {
            details.append(String(localized: "home.latest.note") + " \(latest.notes)")
        }

        return details
    }

    private func displayName(for symptomType: String) -> String {
        symptomType
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
}
