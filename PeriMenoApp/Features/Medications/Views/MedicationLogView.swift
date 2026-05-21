import SwiftData
import SwiftUI

struct MedicationLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<MedicationProfile> { $0.isActive }) private var activeProfiles: [MedicationProfile]
    @StateObject private var viewModel = MedicationLogViewModel()

    var body: some View {
        Form {
            Section("medications.section.active") {
                if activeProfiles.isEmpty {
                    Text("medications.empty")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(activeProfiles) { profile in
                        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(profile.name)
                                    Text(localizedCategory(profile.category))
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button {
                                    modelContext.insert(viewModel.makeEvent(for: profile))
                                    try? modelContext.save()
                                    Haptics.success()
                                } label: {
                                    Label("medications.markTaken", systemImage: "checkmark.circle")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
            }

            Section("medications.section.event") {
                Stepper(value: $viewModel.draft.perceivedEffectScore, in: 0...5) {
                    HStack {
                        Text("medications.effectScore")
                        Spacer()
                        Text("\(viewModel.draft.perceivedEffectScore)")
                            .foregroundStyle(.secondary)
                    }
                }
                TextField("medications.sideEffect.placeholder", text: $viewModel.draft.sideEffectNote, axis: .vertical)
            }

            Section("medications.section.add") {
                TextField("medications.name.placeholder", text: $viewModel.draft.name)
                TextField("medications.dose.placeholder", text: $viewModel.draft.dose)
                TextField("medications.frequency.placeholder", text: $viewModel.draft.frequency)
                Picker("medications.category", selection: $viewModel.draft.category) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Text(localizedCategory(category))
                            .tag(category)
                    }
                }
                Button {
                    let profile = viewModel.makeProfile()
                    modelContext.insert(profile)
                    try? modelContext.save()
                    viewModel.resetProfileFields()
                    Haptics.success()
                } label: {
                    Label("medications.add", systemImage: "plus.circle")
                }
                .disabled(viewModel.draft.name.isEmpty)
            }
        }
        .navigationTitle("medications.title")
    }

    private func localizedCategory(_ category: String) -> LocalizedStringResource {
        switch category {
        case "HRT":
            "medication.category.hrt"
        case "prescription":
            "medication.category.prescription"
        case "OTC":
            "medication.category.otc"
        case "other":
            "medication.category.other"
        default:
            "medication.category.supplement"
        }
    }
}
