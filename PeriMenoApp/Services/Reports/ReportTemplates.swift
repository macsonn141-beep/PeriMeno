import Foundation

struct ReportSummary {
    let generatedAt: Date
    let rangeLabel: String
    let entries: [DailyEntry]
    let topSymptoms: [(name: String, count: Int, averageSeverity: Double)]
    let averageMood: Double?
    let averageSleep: Double?
    let averageEnergy: Double?
    let averageBrainFog: Double?
    let brainFogEntryCount: Int
    let cycleNotes: [String]
    let medicationSummary: String?
    let userNotes: [String]

    var entryCount: Int {
        entries.count
    }

    var dateRangeText: String {
        guard let first = entries.last, let last = entries.first else {
            return String(localized: "reports.summary.dateRange.empty")
        }
        return "\(first.date.pmShortDate) - \(last.date.pmShortDate)"
    }

    var hasLimitedData: Bool {
        entryCount < 3
    }
}

enum ReportTemplates {
    static func makeSummary(entries: [DailyEntry], range: ReportRange) -> ReportSummary {
        let sortedEntries = entries.sorted { $0.date > $1.date }
        let symptoms = sortedEntries.flatMap(\.symptoms)
        let topSymptoms = Dictionary(grouping: symptoms, by: \.symptomType)
            .map { symptom, logs in
                let averageSeverity = average(logs.map(\.severity)) ?? 0
                return (name: symptom, count: logs.count, averageSeverity: averageSeverity)
            }
            .sorted { lhs, rhs in
                if lhs.count == rhs.count {
                    return lhs.name < rhs.name
                }
                return lhs.count > rhs.count
            }

        let cycleNotes = sortedEntries
            .compactMap { entry -> String? in
                guard let cycleLog = entry.cycleLog else { return nil }
                let note = cycleLog.note.trimmingCharacters(in: .whitespacesAndNewlines)
                if cycleLog.bleedingType == "none" && note.isEmpty {
                    return nil
                }
                let detail = note.isEmpty ? cycleLog.bleedingType : "\(cycleLog.bleedingType), \(note)"
                return "\(entry.date.pmShortDate): \(detail)"
            }

        let medicationEvents = sortedEntries.flatMap(\.medicationsTaken)
        let medicationSummary = medicationEvents.isEmpty
            ? nil
            : String(localized: "reports.summary.medications") + " \(medicationEvents.count)"

        let userNotes = sortedEntries
            .compactMap { entry -> String? in
                let note = entry.notes.trimmingCharacters(in: .whitespacesAndNewlines)
                return note.isEmpty ? nil : "\(entry.date.pmShortDate): \(note)"
            }

        return ReportSummary(
            generatedAt: .now,
            rangeLabel: range.exportLabel,
            entries: sortedEntries,
            topSymptoms: Array(topSymptoms.prefix(8)),
            averageMood: average(sortedEntries.map(\.moodScore)),
            averageSleep: average(sortedEntries.map(\.sleepScore)),
            averageEnergy: average(sortedEntries.map(\.energyScore)),
            averageBrainFog: average(sortedEntries.map(\.brainFogScore)),
            brainFogEntryCount: sortedEntries.filter(\.usedBrainFogMode).count,
            cycleNotes: Array(cycleNotes.prefix(8)),
            medicationSummary: medicationSummary,
            userNotes: Array(userNotes.prefix(8))
        )
    }

    static func previewText(kind: ReportKind, summary: ReportSummary) -> String {
        switch kind {
        case .doctor:
            return doctorSummary(summary: summary)
        case .selfSummary:
            return selfSummary(summary: summary)
        }
    }

    static func doctorSummary(entries: [DailyEntry], appointmentPrep: AppointmentPrep?) -> String {
        let summary = makeSummary(entries: entries, range: .last30)
        return doctorSummary(summary: summary, appointmentPrep: appointmentPrep)
    }

    static func doctorSummary(summary: ReportSummary, appointmentPrep: AppointmentPrep? = nil) -> String {
        var sections = baseSummaryLines(summary: summary)
        sections.append(symptomFrequencyText(summary: summary, appointmentPrep: appointmentPrep))
        sections.append(ratingsSummaryText(summary: summary))
        sections.append(brainFogSummaryText(summary: summary))
        sections.append(cycleSummaryText(summary: summary))
        sections.append(medicationSummaryText(summary: summary, appointmentPrep: appointmentPrep))
        sections.append(notesSummaryText(summary: summary))
        sections.append(String(localized: "report.disclaimer"))
        return sections.joined(separator: "\n\n")
    }

    static func selfSummary(summary: ReportSummary) -> String {
        [
            baseSummaryLines(summary: summary).joined(separator: "\n"),
            symptomFrequencyText(summary: summary),
            ratingsSummaryText(summary: summary),
            notesSummaryText(summary: summary)
        ].joined(separator: "\n\n")
    }

    static func baseSummaryLines(summary: ReportSummary) -> [String] {
        var lines = [
            String(localized: "reports.summary.generated") + " \(summary.generatedAt.pmReportDate)",
            String(localized: "reports.summary.selectedRange") + " \(summary.rangeLabel)",
            String(localized: "reports.summary.dateRange") + " \(summary.dateRangeText)",
            String(localized: "reports.summary.entries") + " \(summary.entryCount)"
        ]

        if summary.hasLimitedData {
            lines.append(String(localized: "reports.summary.lowData"))
        }

        return lines
    }

    static func symptomFrequencyText(summary: ReportSummary, appointmentPrep: AppointmentPrep? = nil) -> String {
        if let appointmentSymptoms = appointmentPrep?.topSymptomsSummary.nonEmpty {
            return appointmentSymptoms
        }

        guard !summary.topSymptoms.isEmpty else {
            return String(localized: "reports.summary.topSymptoms.placeholder")
        }

        let rows = summary.topSymptoms.map {
            "- \($0.name): \($0.count) " + String(localized: "reports.summary.times") + ", " + String(localized: "reports.summary.averageSeverity") + " \(formatScore($0.averageSeverity))"
        }

        return String(localized: "reports.summary.topSymptoms") + "\n" + rows.joined(separator: "\n")
    }

    static func ratingsSummaryText(summary: ReportSummary) -> String {
        let mood = formatOptionalScore(summary.averageMood)
        let sleep = formatOptionalScore(summary.averageSleep)
        let energy = formatOptionalScore(summary.averageEnergy)
        let brainFog = formatOptionalScore(summary.averageBrainFog)
        return [
            String(localized: "reports.summary.ratings"),
            "- " + String(localized: "reports.summary.mood") + " \(mood)",
            "- " + String(localized: "reports.summary.sleep") + " \(sleep)",
            "- " + String(localized: "reports.summary.energy") + " \(energy)",
            "- " + String(localized: "reports.summary.brainFog") + " \(brainFog)"
        ].joined(separator: "\n")
    }

    static func brainFogSummaryText(summary: ReportSummary) -> String {
        let percent = summary.entryCount == 0 ? 0 : Int((Double(summary.brainFogEntryCount) / Double(summary.entryCount) * 100).rounded())
        return String(localized: "reports.summary.brainFogMode") + " \(summary.brainFogEntryCount)/\(summary.entryCount) (\(percent)%)"
    }

    static func cycleSummaryText(summary: ReportSummary) -> String {
        guard !summary.cycleNotes.isEmpty else {
            return String(localized: "reports.summary.cycle.placeholder")
        }
        return String(localized: "reports.summary.cycle") + "\n- " + summary.cycleNotes.joined(separator: "\n- ")
    }

    static func medicationSummaryText(summary: ReportSummary, appointmentPrep: AppointmentPrep? = nil) -> String {
        if let appointmentMedication = appointmentPrep?.medicationSummary.nonEmpty {
            return appointmentMedication
        }
        return summary.medicationSummary ?? String(localized: "reports.summary.medications.placeholder")
    }

    static func notesSummaryText(summary: ReportSummary) -> String {
        guard !summary.userNotes.isEmpty else {
            return String(localized: "reports.summary.notes.placeholder")
        }
        return String(localized: "reports.summary.notes") + "\n- " + summary.userNotes.joined(separator: "\n- ")
    }

    private static func average(_ values: [Int]) -> Double? {
        guard !values.isEmpty else { return nil }
        return Double(values.reduce(0, +)) / Double(values.count)
    }

    private static func formatOptionalScore(_ value: Double?) -> String {
        guard let value else {
            return String(localized: "reports.summary.notEnoughData")
        }
        return formatScore(value) + "/5"
    }

    private static func formatScore(_ value: Double) -> String {
        String(format: "%.1f", value)
    }
}

private extension String {
    var nonEmpty: String? {
        isEmpty ? nil : self
    }
}
