import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppState
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]
    @StateObject private var viewModel = SettingsViewModel()
    @State private var placeholderMessage: String?
    @State private var debugMessage: String?
    @State private var shouldConfirmReset = false

    var body: some View {
        List {
            Section("settings.section.preferences") {
                Toggle("settings.notifications", isOn: $viewModel.notificationsEnabled)
                Toggle("settings.faceID", isOn: $appState.faceIDEnabled)
            }

            Section("settings.section.privacy") {
                Text("settings.privacy.summary")
                    .foregroundStyle(.secondary)
            }

            #if DEBUG
            Section("settings.section.debug") {
                Button {
                    seedSampleData()
                } label: {
                    Label("settings.debug.seedSampleData", systemImage: "leaf")
                }

                Button(role: .destructive) {
                    shouldConfirmReset = true
                } label: {
                    Label("settings.debug.resetData", systemImage: "trash")
                }
                .disabled(entries.isEmpty)
            }
            #endif

            Section {
                ForEach(viewModel.rows) { row in
                    if let route = row.route {
                        NavigationLink(value: route) {
                            Label(row.title, systemImage: row.systemImage)
                        }
                    } else {
                        Button {
                            placeholderMessage = String(
                                format: String.pmLocalized( "settings.placeholder.messageFormat"),
                                String.pmLocalized( row.title)
                            )
                            Logger.debug("Settings placeholder tapped: \(row.id)")
                        } label: {
                            Label(row.title, systemImage: row.systemImage)
                        }
                    }
                }
            }

        }
        .navigationTitle("settings.title")
        .alert("settings.placeholder.title", isPresented: placeholderIsPresented) {
            Button("common.ok", role: .cancel) {
                placeholderMessage = nil
            }
        } message: {
            Text(placeholderMessage ?? "")
        }
        .alert("settings.debug.message.title", isPresented: debugMessageIsPresented) {
            Button("common.ok", role: .cancel) {
                debugMessage = nil
            }
        } message: {
            Text(debugMessage ?? "")
        }
        .alert("settings.debug.resetConfirm.title", isPresented: $shouldConfirmReset) {
            Button("settings.debug.resetConfirm.cancel", role: .cancel) { }
            Button("settings.debug.resetConfirm.delete", role: .destructive) {
                resetLocalData()
            }
        } message: {
            Text("settings.debug.resetConfirm.message")
        }
    }

    private var placeholderIsPresented: Binding<Bool> {
        Binding {
            placeholderMessage != nil
        } set: { isPresented in
            if !isPresented {
                placeholderMessage = nil
            }
        }
    }

    private var debugMessageIsPresented: Binding<Bool> {
        Binding {
            debugMessage != nil
        } set: { isPresented in
            if !isPresented {
                debugMessage = nil
            }
        }
    }

    private func seedSampleData() {
        SampleData.makeEntries().forEach { modelContext.insert($0) }
        try? modelContext.save()
        debugMessage = String.pmLocalized( "settings.debug.seededMessage")
    }

    private func resetLocalData() {
        entries.forEach { modelContext.delete($0) }
        try? modelContext.save()
        debugMessage = String.pmLocalized( "settings.debug.resetMessage")
    }
}
