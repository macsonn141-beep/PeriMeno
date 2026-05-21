import SwiftData
import SwiftUI

struct LogEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppState
    @Query(filter: #Predicate<MedicationProfile> { $0.isActive }) private var activeMedications: [MedicationProfile]
    @StateObject private var viewModel = LogEntryViewModel()
    @State private var didSaveEntry = false

    var body: some View {
        Form {
            Section("log.section.symptoms") {
                ForEach(SymptomCatalog.defaults.prefix(8)) { symptom in
                    Toggle(isOn: binding(for: symptom.id)) {
                        Label(symptom.localizationKey, systemImage: symptom.iconName)
                    }
                }

                Button {
                    appState.push(.symptomsPicker, on: .log)
                } label: {
                    Label("log.symptoms.more", systemImage: "magnifyingglass")
                }
            }

            Section("log.section.scores") {
                scoreStepper("log.overall", value: $viewModel.draft.overallScore)
                scoreStepper("log.mood", value: $viewModel.draft.moodScore)
                scoreStepper("log.energy", value: $viewModel.draft.energyScore)
                scoreStepper("log.sleep", value: $viewModel.draft.sleepScore)
                scoreStepper("log.brainFog", value: $viewModel.draft.brainFogScore)
            }

            Section("log.section.cycle") {
                Picker("cycle.bleedingType", selection: $viewModel.draft.bleedingType) {
                    Text("cycle.bleeding.none").tag("none")
                    Text("cycle.bleeding.spotting").tag("spotting")
                    Text("cycle.bleeding.light").tag("light")
                    Text("cycle.bleeding.moderate").tag("moderate")
                    Text("cycle.bleeding.heavy").tag("heavy")
                }
                scoreStepper("cycle.flowLevel", value: $viewModel.draft.flowLevel)
                scoreStepper("cycle.crampLevel", value: $viewModel.draft.crampLevel)
                TextField("cycle.note.placeholder", text: $viewModel.draft.cycleNote, axis: .vertical)
            }

            Section("log.section.triggers") {
                ForEach(TriggerCatalog.defaults) { trigger in
                    Toggle(isOn: triggerBinding(for: trigger.id)) {
                        Text(trigger.localizationKey)
                    }
                }
            }

            Section("log.section.medications") {
                Toggle("log.medication.taken", isOn: $viewModel.draft.tookMedication)
                if viewModel.draft.tookMedication {
                    if activeMedications.isEmpty {
                        Text("log.medication.empty")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("log.medication.profile", selection: $viewModel.draft.selectedMedicationProfileID) {
                            Text("log.medication.select").tag(UUID?.none)
                            ForEach(activeMedications) { profile in
                                Text(profile.name).tag(Optional(profile.id))
                            }
                        }
                    }
                }
            }

            Section("log.section.impact") {
                scoreStepper("log.impact.work", value: $viewModel.draft.impactWork)
                scoreStepper("log.impact.sleep", value: $viewModel.draft.impactSleep)
                scoreStepper("log.impact.relationship", value: $viewModel.draft.impactRelationship)
                scoreStepper("log.impact.intimacy", value: $viewModel.draft.impactIntimacy)
            }

            Section("log.section.notes") {
                TextField("log.notes.placeholder", text: $viewModel.draft.notes, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle("log.title")
        .safeAreaInset(edge: .bottom) {
            Button {
                saveEntry()
            } label: {
                Label("common.save", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ThemeSpacing.small)
            }
            .buttonStyle(.borderedProminent)
            .tint(ThemeColors.accentPrimary)
            .padding(.horizontal)
            .padding(.top, ThemeSpacing.small)
            .background(.regularMaterial)
        }
        .alert("log.saved.title", isPresented: $didSaveEntry) {
            Button("common.ok", role: .cancel) { }
        } message: {
            Text("log.saved.message")
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    appState.push(.entryHistory, on: .log)
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                }
                .accessibilityLabel("entry.history.title")
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    appState.push(.brainFogMode, on: .log)
                } label: {
                    Image(systemName: "brain.head.profile")
                }
                .accessibilityLabel("brainFog.title")
            }
        }
    }

    private func binding(for symptomID: String) -> Binding<Bool> {
        Binding {
            viewModel.draft.selectedSymptomIDs.contains(symptomID)
        } set: { isSelected in
            if isSelected {
                viewModel.draft.selectedSymptomIDs.insert(symptomID)
            } else {
                viewModel.draft.selectedSymptomIDs.remove(symptomID)
            }
        }
    }

    private func triggerBinding(for triggerID: String) -> Binding<Bool> {
        Binding {
            viewModel.draft.selectedTriggerIDs.contains(triggerID)
        } set: { isSelected in
            if isSelected {
                viewModel.draft.selectedTriggerIDs.insert(triggerID)
            } else {
                viewModel.draft.selectedTriggerIDs.remove(triggerID)
            }
        }
    }

    private func scoreStepper(_ title: LocalizedStringResource, value: Binding<Int>) -> some View {
        Stepper(value: value, in: 0...5) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value.wrappedValue)")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func saveEntry() {
        modelContext.insert(viewModel.makeEntry())
        try? modelContext.save()
        Haptics.success()
        viewModel.reset()
        didSaveEntry = true
    }
}

struct EntryHistoryView: View {
    @EnvironmentObject private var appState: AppState
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]

    var body: some View {
        Group {
            if entries.isEmpty {
                VStack(spacing: ThemeSpacing.large) {
                    PMEmptyStateView(
                        title: "entry.history.empty.title",
                        message: "entry.history.empty.message",
                        systemImage: "calendar.badge.clock"
                    )

                    Button {
                        appState.selectedTab = .log
                    } label: {
                        Label("entry.history.empty.cta", systemImage: "plus.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(ThemeColors.accentPrimary)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(ThemeColors.backgroundPrimary)
            } else {
                List {
                    ForEach(entries) { entry in
                        NavigationLink {
                            EntryDetailView(entry: entry)
                        } label: {
                            EntryHistoryRow(entry: entry)
                        }
                    }
                }
            }
        }
        .navigationTitle("entry.history.title")
    }
}

private struct EntryHistoryRow: View {
    let entry: DailyEntry

    var body: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.xSmall) {
            HStack(alignment: .firstTextBaseline) {
                Text(entry.date.pmReportDate)
                    .font(.headline)
                Spacer()
                if entry.usedBrainFogMode {
                    Label("entry.history.brainFog", systemImage: "brain.head.profile")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(ThemeColors.accentPrimary)
                }
            }

            Text(scoreSummary)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(symptomSummary)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, ThemeSpacing.xSmall)
    }

    private var scoreSummary: String {
        String(localized: "entry.history.scores") + " \(entry.overallScore)/5"
    }

    private var symptomSummary: String {
        if let symptom = entry.symptoms.sorted(by: { $0.severity > $1.severity }).first {
            return String(localized: "entry.history.topSymptom") + " \(EntryDisplay.name(for: symptom.symptomType))"
        }
        return String(localized: "entry.history.symptomCount") + " \(entry.symptoms.count)"
    }
}

struct EntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let entry: DailyEntry
    @State private var isEditing = false
    @State private var isConfirmingDelete = false

    var body: some View {
        List {
            Section("entry.detail.section.summary") {
                LabeledContent("entry.detail.date", value: entry.date.pmReportDate)
                LabeledContent("entry.detail.brainFogMode") {
                    Text(entry.usedBrainFogMode ? "common.yes" : "common.no")
                }
            }

            Section("entry.detail.section.ratings") {
                ratingRow("log.overall", value: entry.overallScore)
                ratingRow("log.mood", value: entry.moodScore)
                ratingRow("log.energy", value: entry.energyScore)
                ratingRow("log.sleep", value: entry.sleepScore)
                ratingRow("log.brainFog", value: entry.brainFogScore)
            }

            Section("entry.detail.section.symptoms") {
                if entry.symptoms.isEmpty {
                    Text("entry.detail.none")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(entry.symptoms.sorted(by: { $0.symptomType < $1.symptomType })) { symptom in
                        LabeledContent(EntryDisplay.name(for: symptom.symptomType)) {
                            Text("\(symptom.severity)/5")
                        }
                    }
                }
            }

            Section("entry.detail.section.notes") {
                Text(entry.notes.isEmpty ? String(localized: "entry.detail.none") : entry.notes)
                    .foregroundStyle(entry.notes.isEmpty ? .secondary : .primary)
            }

            Section("entry.detail.section.triggers") {
                if entry.triggers.isEmpty {
                    Text("entry.detail.none")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(entry.triggers.sorted(by: { $0.triggerType < $1.triggerType })) { trigger in
                        LabeledContent(EntryDisplay.name(for: trigger.triggerType)) {
                            if let intensity = trigger.intensity {
                                Text("\(intensity)/5")
                            } else {
                                Text("entry.detail.logged")
                            }
                        }
                    }
                }
            }

            Section("entry.detail.section.cycle") {
                if let cycleLog = entry.cycleLog {
                    LabeledContent("cycle.bleedingType", value: cycleLog.bleedingType)
                    LabeledContent("cycle.flowLevel", value: "\(cycleLog.flowLevel)/5")
                    LabeledContent("cycle.crampLevel", value: "\(cycleLog.crampLevel)/5")
                    if !cycleLog.note.isEmpty {
                        Text(cycleLog.note)
                    }
                } else {
                    Text("entry.detail.none")
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Button(role: .destructive) {
                    isConfirmingDelete = true
                } label: {
                    Label("entry.detail.delete", systemImage: "trash")
                }
            }
        }
        .navigationTitle("entry.detail.title")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    isConfirmingDelete = true
                } label: {
                    Image(systemName: "trash")
                }
                .accessibilityLabel("entry.detail.delete")

                Button("common.edit") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                EditEntryView(entry: entry)
            }
        }
        .alert("entry.delete.alert.title", isPresented: $isConfirmingDelete) {
            Button("common.cancel", role: .cancel) { }
            Button("entry.detail.delete", role: .destructive) {
                deleteEntry()
            }
        } message: {
            Text("entry.delete.alert.message")
        }
    }

    private func ratingRow(_ title: LocalizedStringResource, value: Int) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value)/5")
                .foregroundStyle(.secondary)
        }
    }

    private func deleteEntry() {
        modelContext.delete(entry)
        try? modelContext.save()
        Haptics.success()
        dismiss()
    }
}

struct EditEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let entry: DailyEntry
    @State private var draft: LogDraft
    @State private var didSave = false

    init(entry: DailyEntry) {
        self.entry = entry
        _draft = State(initialValue: LogDraft(entry: entry))
    }

    var body: some View {
        Form {
            Section("log.section.symptoms") {
                ForEach(SymptomCatalog.defaults.prefix(12)) { symptom in
                    Toggle(isOn: binding(for: symptom.id)) {
                        Label(symptom.localizationKey, systemImage: symptom.iconName)
                    }
                }
            }

            Section("log.section.scores") {
                scoreStepper("log.overall", value: $draft.overallScore)
                scoreStepper("log.mood", value: $draft.moodScore)
                scoreStepper("log.energy", value: $draft.energyScore)
                scoreStepper("log.sleep", value: $draft.sleepScore)
                scoreStepper("log.brainFog", value: $draft.brainFogScore)
            }

            Section("log.section.notes") {
                TextField("log.notes.placeholder", text: $draft.notes, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle("entry.edit.title")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("common.cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("common.save") {
                    saveChanges()
                }
            }
        }
        .alert("entry.edit.saved.title", isPresented: $didSave) {
            Button("common.ok", role: .cancel) {
                DispatchQueue.main.async {
                    dismiss()
                }
            }
        } message: {
            Text("entry.edit.saved.message")
        }
    }

    private func binding(for symptomID: String) -> Binding<Bool> {
        Binding {
            draft.selectedSymptomIDs.contains(symptomID)
        } set: { isSelected in
            if isSelected {
                draft.selectedSymptomIDs.insert(symptomID)
            } else {
                draft.selectedSymptomIDs.remove(symptomID)
            }
        }
    }

    private func scoreStepper(_ title: LocalizedStringResource, value: Binding<Int>) -> some View {
        Stepper(value: value, in: 0...5) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value.wrappedValue)")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func saveChanges() {
        entry.overallScore = draft.overallScore
        entry.moodScore = draft.moodScore
        entry.energyScore = draft.energyScore
        entry.sleepScore = draft.sleepScore
        entry.brainFogScore = draft.brainFogScore
        entry.notes = Validators.trimmed(draft.notes)
        entry.updatedAt = .now

        entry.symptoms.forEach(modelContext.delete)
        entry.symptoms = draft.selectedSymptomIDs
            .sorted()
            .map { SymptomLog(symptomType: $0, severity: draft.overallScore) }

        try? modelContext.save()
        Haptics.success()
        didSave = true
    }
}

private enum EntryDisplay {
    static func name(for id: String) -> String {
        id.replacingOccurrences(of: "_", with: " ").capitalized
    }
}
