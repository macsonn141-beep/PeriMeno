import XCTest
@testable import PeriMeno

final class CorrelationEngineTests: XCTestCase {
    func testCorrelationEngineReturnsSummary() {
        let summary = CorrelationEngine().basicCorrelationSummary(entries: SampleData.previewEntries)
        XCTAssertFalse(summary.isEmpty)
    }
}
