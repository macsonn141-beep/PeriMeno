import Foundation

extension Date {
    var pmShortDate: String {
        Self.shortDateFormatter.string(from: self)
    }

    var pmReportDate: String {
        Self.reportFormatter.string(from: self)
    }

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    private static let reportFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
