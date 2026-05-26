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
            return String.pmLocalized( "home.summary.empty")
        }
        return String.pmLocalized( "home.summary.latest") + " \(latest.symptoms.count)"
    }

    func latestEntryDetails(entries: [DailyEntry], locale: Locale = .current) -> [String] {
        guard let latest = entries.sorted(by: { $0.date > $1.date }).first else {
            return []
        }

        let mood = String.pmLocalized( "home.latest.mood", locale: locale)
        let sleep = String.pmLocalized( "home.latest.sleep", locale: locale)
        let energy = String.pmLocalized( "home.latest.energy", locale: locale)

        var details = [
            String.pmLocalized( "home.latest.date", locale: locale) + " \(latest.date.pmShortDate)",
            "\(mood) \(latest.moodScore)/5 · \(sleep) \(latest.sleepScore)/5 · \(energy) \(latest.energyScore)/5"
        ]

        if let topSymptom = latest.symptoms.first {
            details.append(String.pmLocalized( "home.latest.topSymptom", locale: locale) + " " + displayName(for: topSymptom.symptomType))
        } else {
            details.append(String.pmLocalized( "home.latest.noSymptoms", locale: locale))
        }

        if !latest.notes.isEmpty {
            details.append(String.pmLocalized( "home.latest.note", locale: locale) + " \(latest.notes)")
        }

        return details
    }

    private func displayName(for symptomType: String) -> String {
        String.pmLocalizedKey("symptom.\(symptomType)")
    }
}
