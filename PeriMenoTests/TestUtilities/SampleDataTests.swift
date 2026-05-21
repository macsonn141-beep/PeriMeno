import XCTest
@testable import PeriMeno

final class SampleDataTests: XCTestCase {
    func testPreviewEntriesExist() {
        XCTAssertFalse(SampleData.previewEntries.isEmpty)
    }
}
