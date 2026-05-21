import SwiftData
import SwiftUI

struct CycleLogView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = CycleLogViewModel()

    var body: some View {
        Form {
            Section("cycle.section.flow") {
                Picker("cycle.bleedingType", selection: $viewModel.draft.bleedingType) {
                    ForEach(viewModel.bleedingTypes, id: \.self) { type in
                        Text(localizedBleedingType(type))
                            .tag(type)
                    }
                }
                Stepper(value: $viewModel.draft.flowLevel, in: 0...5) {
                    HStack {
                        Text("cycle.flowLevel")
                        Spacer()
                        Text("\(viewModel.draft.flowLevel)")
                    }
                }
                Stepper(value: $viewModel.draft.crampLevel, in: 0...5) {
                    HStack {
                        Text("cycle.crampLevel")
                        Spacer()
                        Text("\(viewModel.draft.crampLevel)")
                    }
                }
            }

            Section("common.notes") {
                TextField("cycle.note.placeholder", text: $viewModel.draft.note, axis: .vertical)
            }

            Button {
                modelContext.insert(viewModel.makeCycleLog())
                try? modelContext.save()
            } label: {
                Label("common.save", systemImage: "checkmark.circle")
            }
        }
        .navigationTitle("cycle.title")
    }

    private func localizedBleedingType(_ type: String) -> LocalizedStringResource {
        switch type {
        case "spotting":
            "cycle.bleeding.spotting"
        case "light":
            "cycle.bleeding.light"
        case "moderate":
            "cycle.bleeding.moderate"
        case "heavy":
            "cycle.bleeding.heavy"
        default:
            "cycle.bleeding.none"
        }
    }
}
