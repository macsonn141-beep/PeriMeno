import SwiftData
import SwiftUI

struct BrainFogModeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = BrainFogModeViewModel()
    @State private var didSaveEntry = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ThemeSpacing.large) {
                Text("brainFog.prompt")
                    .font(.title2.weight(.semibold))

                HStack(spacing: ThemeSpacing.medium) {
                    ForEach(viewModel.choices) { choice in
                        Button {
                            viewModel.selectedFeelingID = choice.id
                        } label: {
                            Text(choice.title)
                                .font(.headline)
                                .frame(maxWidth: .infinity, minHeight: 64)
                        }
                        .buttonStyle(.bordered)
                        .tint(viewModel.selectedFeelingID == choice.id ? ThemeColors.accentPrimary : ThemeColors.accentSecondary)
                    }
                }

                PMSectionHeader(title: "brainFog.quickSymptoms")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: ThemeSpacing.medium) {
                    ForEach(SymptomCatalog.brainFogPinned) { symptom in
                        Button {
                            toggle(symptom.id)
                        } label: {
                            PMSymptomChip(
                                title: symptom.localizationKey,
                                systemImage: symptom.iconName,
                                isSelected: viewModel.selectedSymptoms.contains(symptom.id)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                TextField("brainFog.note.placeholder", text: $viewModel.quickNote, axis: .vertical)
                    .lineLimit(2...4)
                    .textFieldStyle(.roundedBorder)

                Button {
                    save()
                } label: {
                    Text("brainFog.save")
                        .frame(maxWidth: .infinity, minHeight: 56)
                }
                .buttonStyle(.borderedProminent)
                .tint(ThemeColors.accentPrimary)
            }
            .padding()
        }
        .background(ThemeColors.backgroundPrimary)
        .navigationTitle("brainFog.title")
        .alert("brainFog.saved.title", isPresented: $didSaveEntry) {
            Button("common.done") {
                close()
            }
        } message: {
            Text("brainFog.saved.message")
        }
    }

    private func toggle(_ symptomID: String) {
        if viewModel.selectedSymptoms.contains(symptomID) {
            viewModel.selectedSymptoms.remove(symptomID)
        } else {
            viewModel.selectedSymptoms.insert(symptomID)
        }
    }

    private func save() {
        let entry = viewModel.makeEntry()
        modelContext.insert(entry)
        try? modelContext.save()
        viewModel.reset()
        Haptics.success()
        didSaveEntry = true
    }

    private func close() {
        if appState.router.homePath.isEmpty && appState.router.logPath.isEmpty {
            dismiss()
        } else {
            appState.popCurrentRoute()
        }
    }
}
