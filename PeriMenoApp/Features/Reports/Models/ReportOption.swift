import SwiftUI

struct ReportOption: Identifiable {
    let id: String
    let title: LocalizedStringResource
    let detail: LocalizedStringResource
    let isPremium: Bool
}

enum ReportKind: String {
    case doctor
    case selfSummary = "self"

    init?(optionID: String) {
        switch optionID {
        case Self.doctor.rawValue:
            self = .doctor
        case Self.selfSummary.rawValue:
            self = .selfSummary
        default:
            return nil
        }
    }

    var title: String {
        switch self {
        case .doctor:
            return String.pmLocalized( "reports.pdf.title.doctor")
        case .selfSummary:
            return String.pmLocalized( "reports.pdf.title.self")
        }
    }

    var fileNamePrefix: String {
        switch self {
        case .doctor:
            return "PeriMeno-Doctor-Report"
        case .selfSummary:
            return "PeriMeno-Self-Summary"
        }
    }
}

enum ReportRange: String, CaseIterable, Identifiable {
    case last7
    case last30
    case last90

    var id: String { rawValue }

    var days: Int {
        switch self {
        case .last7:
            return 7
        case .last30:
            return 30
        case .last90:
            return 90
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .last7:
            return "reports.range.last7"
        case .last30:
            return "reports.range.last30"
        case .last90:
            return "reports.range.last90"
        }
    }

    var exportLabel: String {
        switch self {
        case .last7:
            return String.pmLocalized( "reports.range.last7")
        case .last30:
            return String.pmLocalized( "reports.range.last30")
        case .last90:
            return String.pmLocalized( "reports.range.last90")
        }
    }

    func contains(_ date: Date, now: Date = .now, calendar: Calendar = .current) -> Bool {
        guard let start = calendar.date(byAdding: .day, value: -(days - 1), to: calendar.startOfDay(for: now)) else {
            return true
        }
        return date >= start && date <= now
    }
}

struct GeneratedReport: Identifiable {
    let id = UUID()
    let url: URL
    let title: String
    let byteCount: Int
}
