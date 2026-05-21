import SwiftData
import SwiftUI

struct AppointmentBuilderView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]
    @StateObject private var viewModel = AppointmentBuilderViewModel()

    var body: some View {
        List {
            Section("appointment.section.summary") {
                Text("appointment.summary.placeholder")
                    .foregroundStyle(.secondary)
            }

            Section("appointment.section.questions") {
                ForEach(viewModel.questions) { question in
                    Label(question.text, systemImage: "questionmark.circle")
                }
            }

            Section {
                Button {
                    modelContext.insert(viewModel.makePrep(entries: entries))
                    try? modelContext.save()
                } label: {
                    Label("appointment.save", systemImage: "checkmark.circle")
                }
            }
        }
        .navigationTitle("appointment.title")
    }
}
