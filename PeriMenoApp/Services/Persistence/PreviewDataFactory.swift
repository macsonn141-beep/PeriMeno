import SwiftData

enum PreviewDataFactory {
    @MainActor
    static func previewContainer() -> ModelContainer {
        let container = PersistenceController.makeContainer(inMemory: true)
        SampleData.previewEntries.forEach { container.mainContext.insert($0) }
        return container
    }
}
