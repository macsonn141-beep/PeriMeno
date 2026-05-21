import PDFKit
import SwiftData
import SwiftUI

struct ReportsExportView: View {
    @EnvironmentObject private var appState: AppState
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]
    @StateObject private var viewModel = ReportsExportViewModel()
    @State private var previewReport: GeneratedReport?

    var body: some View {
        List {
            Section("reports.range.title") {
                Picker("reports.range.title", selection: $viewModel.selectedRange) {
                    ForEach(ReportRange.allCases) { range in
                        Text(range.title).tag(range)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("reports.section.options") {
                ForEach(viewModel.options) { option in
                    if option.isPremium && !appState.isPremiumUnlocked {
                        NavigationLink(value: AppRoute.paywall) {
                            reportRow(option: option)
                        }
                    } else {
                        Button {
                            viewModel.preparePreview(entries: entries, option: option)
                        } label: {
                            reportRow(option: option)
                        }
                    }
                }
            }

            if !viewModel.previewText.isEmpty {
                Section("reports.section.preview") {
                    Button {
                        viewModel.buildPDFPreview(entries: entries)
                    } label: {
                        Label("reports.pdf.buildPreview", systemImage: "doc.richtext")
                    }

                    if !viewModel.pdfStatusText.isEmpty {
                        Text(viewModel.pdfStatusText)
                            .foregroundStyle(.secondary)
                    }

                    if let report = viewModel.generatedReport {
                        Button {
                            previewReport = report
                        } label: {
                            Label("reports.pdf.previewFile", systemImage: "doc.text.magnifyingglass")
                        }

                        ShareLink(item: report.url) {
                            Label("reports.pdf.share", systemImage: "square.and.arrow.up")
                        }
                    }

                    Text(viewModel.previewText)
                        .font(.footnote.monospaced())
                        .lineLimit(8)
                        .textSelection(.enabled)
                }
            }

            Section {
                Button {
                    appState.push(.appointmentBuilder, on: .reports)
                } label: {
                    Label("reports.appointment.open", systemImage: "stethoscope")
                }
            }
        }
        .navigationTitle("reports.title")
        .sheet(item: $previewReport) { report in
            ReportPDFPreview(report: report)
        }
    }

    private func reportRow(option: ReportOption) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: ThemeSpacing.xSmall) {
                Text(option.title)
                    .font(.headline)
                Text(option.detail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if option.isPremium {
                PMPremiumBadge()
            }
        }
        .contentShape(Rectangle())
    }
}

private struct ReportPDFPreview: View {
    @Environment(\.dismiss) private var dismiss

    let report: GeneratedReport

    var body: some View {
        NavigationStack {
            PDFKitPreview(url: report.url)
                .navigationTitle(report.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("common.done") {
                            dismiss()
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        ShareLink(item: report.url) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
        }
    }
}

private struct PDFKitPreview: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displayDirection = .vertical
        view.document = PDFDocument(url: url)
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if uiView.document?.documentURL != url {
            uiView.document = PDFDocument(url: url)
        }
    }
}
