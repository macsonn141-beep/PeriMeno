import Foundation

@MainActor
final class ReportsExportViewModel: ObservableObject {
    @Published var selectedRange: ReportRange = .last30 {
        didSet {
            guard let selectedOption else { return }
            preparePreview(entries: lastEntries, option: selectedOption)
        }
    }

    @Published private(set) var previewText = ""
    @Published private(set) var pdfStatusText = ""
    @Published private(set) var generatedReport: GeneratedReport?
    @Published private(set) var selectedOption: ReportOption?

    private let pdfBuilder = PDFReportBuilder()
    private var lastEntries: [DailyEntry] = []

    let options = [
        ReportOption(id: "doctor", title: "reports.option.doctor", detail: "reports.option.doctor.detail", isPremium: true),
        ReportOption(id: "self", title: "reports.option.self", detail: "reports.option.self.detail", isPremium: false),
        ReportOption(id: "partner", title: "reports.option.partner", detail: "reports.option.partner.detail", isPremium: true)
    ]

    func preparePreview(entries: [DailyEntry], option: ReportOption) {
        lastEntries = entries
        selectedOption = option
        generatedReport = nil

        guard let kind = ReportKind(optionID: option.id) else {
            previewText = ""
            pdfStatusText = String(localized: "reports.pdf.placeholderUnavailable")
            return
        }

        let filteredEntries = filtered(entries: entries)
        guard !filteredEntries.isEmpty else {
            previewText = ""
            pdfStatusText = String(localized: "reports.pdf.empty")
            return
        }

        let summary = ReportTemplates.makeSummary(entries: filteredEntries, range: selectedRange)
        previewText = ReportTemplates.previewText(kind: kind, summary: summary)
        pdfStatusText = summary.hasLimitedData ? String(localized: "reports.pdf.lowData") : ""
    }

    func buildPDFPreview(entries: [DailyEntry]) {
        lastEntries = entries
        generatedReport = nil

        guard let selectedOption, let kind = ReportKind(optionID: selectedOption.id) else {
            pdfStatusText = String(localized: "reports.pdf.chooseType")
            return
        }

        let filteredEntries = filtered(entries: entries)
        guard !filteredEntries.isEmpty else {
            pdfStatusText = String(localized: "reports.pdf.empty")
            return
        }

        let summary = ReportTemplates.makeSummary(entries: filteredEntries, range: selectedRange)
        let data = pdfBuilder.buildReport(kind: kind, summary: summary)
        do {
            let url = try writePDF(data: data, kind: kind, summary: summary)
            generatedReport = GeneratedReport(url: url, title: kind.title, byteCount: data.count)
            pdfStatusText = String(localized: "reports.pdf.ready") + " \(data.count) " + String(localized: "reports.pdf.bytes")
        } catch {
            pdfStatusText = String(localized: "reports.pdf.failed") + " \(error.localizedDescription)"
        }
    }

    private func filtered(entries: [DailyEntry]) -> [DailyEntry] {
        entries
            .filter { selectedRange.contains($0.date) }
            .sorted { $0.date > $1.date }
    }

    private func writePDF(data: Data, kind: ReportKind, summary: ReportSummary) throws -> URL {
        let dateToken = ISO8601DateFormatter()
            .string(from: summary.generatedAt)
            .replacingOccurrences(of: ":", with: "-")
        let filename = "\(kind.fileNamePrefix)-\(selectedRange.rawValue)-\(dateToken).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try data.write(to: url, options: .atomic)
        return url
    }
}
