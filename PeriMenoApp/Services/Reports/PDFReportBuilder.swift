import Foundation
import PDFKit
import UIKit

struct PDFReportBuilder {
    func buildReport(kind: ReportKind, summary: ReportSummary) -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: PDFLayout.pageBounds)
        return renderer.pdfData { context in
            let writer = PDFTextWriter(context: context)
            writer.beginPage()
            writer.drawHeader(title: kind.title, subtitle: "PeriMeno")

            writer.drawSection(
                title: String.pmLocalized( "reports.pdf.section.summary"),
                body: ReportTemplates.baseSummaryLines(summary: summary).joined(separator: "\n")
            )

            writer.drawSection(
                title: String.pmLocalized( "reports.pdf.section.symptoms"),
                body: ReportTemplates.symptomFrequencyText(summary: summary)
            )

            writer.drawSection(
                title: String.pmLocalized( "reports.pdf.section.ratings"),
                body: ReportTemplates.ratingsSummaryText(summary: summary)
            )

            if kind == .doctor {
                writer.drawSection(
                    title: String.pmLocalized( "reports.pdf.section.brainFog"),
                    body: ReportTemplates.brainFogSummaryText(summary: summary)
                )
                writer.drawSection(
                    title: String.pmLocalized( "reports.pdf.section.cycle"),
                    body: ReportTemplates.cycleSummaryText(summary: summary)
                )
                writer.drawSection(
                    title: String.pmLocalized( "reports.pdf.section.medications"),
                    body: ReportTemplates.medicationSummaryText(summary: summary)
                )
            }

            writer.drawSection(
                title: String.pmLocalized( "reports.pdf.section.notes"),
                body: ReportTemplates.notesSummaryText(summary: summary)
            )

            writer.finish()
        }
    }

    func buildDoctorReport(entries: [DailyEntry], appointmentPrep: AppointmentPrep?) -> Data {
        let summary = ReportTemplates.makeSummary(entries: entries, range: .last30)
        return buildReport(kind: .doctor, summary: summary)
    }

    func makeDocument(from data: Data) -> PDFDocument? {
        PDFDocument(data: data)
    }
}

private enum PDFLayout {
    static let pageBounds = CGRect(x: 0, y: 0, width: 612, height: 792)
    static let margin: CGFloat = 44
    static let footerHeight: CGFloat = 54
    static let contentWidth = pageBounds.width - margin * 2
    static let bottomLimit = pageBounds.height - footerHeight
}

private final class PDFTextWriter {
    private let context: UIGraphicsPDFRendererContext
    private var y: CGFloat = PDFLayout.margin
    private var pageNumber = 0

    private let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.preferredFont(forTextStyle: .title1).withTraits(.traitBold),
        .foregroundColor: UIColor.label
    ]

    private let subtitleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.preferredFont(forTextStyle: .subheadline),
        .foregroundColor: UIColor.secondaryLabel
    ]

    private let sectionAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.preferredFont(forTextStyle: .headline).withTraits(.traitBold),
        .foregroundColor: UIColor.label
    ]

    private let bodyAttributes: [NSAttributedString.Key: Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.paragraphSpacing = 4
        return [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ]
    }()

    private let footerAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.preferredFont(forTextStyle: .footnote),
        .foregroundColor: UIColor.secondaryLabel
    ]

    init(context: UIGraphicsPDFRendererContext) {
        self.context = context
    }

    func beginPage() {
        context.beginPage()
        pageNumber += 1
        y = PDFLayout.margin
    }

    func drawHeader(title: String, subtitle: String) {
        drawText(title, attributes: titleAttributes, spacingAfter: 6)
        drawText(subtitle, attributes: subtitleAttributes, spacingAfter: 20)
    }

    func drawSection(title: String, body: String) {
        ensureSpace(90)
        drawText(title, attributes: sectionAttributes, spacingAfter: 8)

        body.components(separatedBy: .newlines).forEach { line in
            let text = line.isEmpty ? " " : line
            drawText(text, attributes: bodyAttributes, spacingAfter: 4)
        }

        y += 10
    }

    func finish() {
        drawFooter()
    }

    private func drawText(_ text: String, attributes: [NSAttributedString.Key: Any], spacingAfter: CGFloat) {
        let height = measuredHeight(for: text, attributes: attributes)
        ensureSpace(height + spacingAfter)
        let rect = CGRect(x: PDFLayout.margin, y: y, width: PDFLayout.contentWidth, height: height)
        (text as NSString).draw(in: rect, withAttributes: attributes)
        y += height + spacingAfter
    }

    private func measuredHeight(for text: String, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let rect = (text as NSString).boundingRect(
            with: CGSize(width: PDFLayout.contentWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        return ceil(rect.height) + 2
    }

    private func ensureSpace(_ neededHeight: CGFloat) {
        guard y + neededHeight > PDFLayout.bottomLimit else { return }
        drawFooter()
        beginPage()
    }

    private func drawFooter() {
        let disclaimer = String.pmLocalized( "report.disclaimer")
        let footer = "\(disclaimer)\n" + String.pmLocalized( "reports.pdf.page") + " \(pageNumber)"
        let rect = CGRect(
            x: PDFLayout.margin,
            y: PDFLayout.pageBounds.height - PDFLayout.footerHeight + 8,
            width: PDFLayout.contentWidth,
            height: PDFLayout.footerHeight - 12
        )
        (footer as NSString).draw(in: rect, withAttributes: footerAttributes)
    }
}

private extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
