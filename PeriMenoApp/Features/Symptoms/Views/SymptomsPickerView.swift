import SwiftData
import SwiftUI

struct SymptomsPickerView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SymptomsPickerViewModel()
    @State private var customSymptomName = ""

    var body: some View {
        List {
            Section("symptoms.section.default") {
                ForEach(viewModel.filteredSymptoms) { symptom in
                    Label(symptom.localizationKey, systemImage: symptom.iconName)
                }
            }

            Section {
                TextField("symptoms.custom.placeholder", text: $customSymptomName)
                Button {
                    addCustomSymptom()
                } label: {
                    Label("symptoms.addCustom", systemImage: "plus")
                }
                .disabled(Validators.trimmed(customSymptomName).isEmpty)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "symptoms.search")
        .navigationTitle("symptoms.title")
    }

    private func addCustomSymptom() {
        let symptom = CustomSymptom(name: Validators.trimmed(customSymptomName))
        modelContext.insert(symptom)
        try? modelContext.save()
        customSymptomName = ""
        Haptics.success()
    }
}
