import Foundation

@MainActor
final class SymptomsPickerViewModel: ObservableObject {
    @Published var searchText = ""

    var filteredSymptoms: [SymptomDefinition] {
        guard !searchText.isEmpty else { return SymptomCatalog.defaults }
        return SymptomCatalog.defaults.filter { $0.id.localizedCaseInsensitiveContains(searchText) }
    }
}
