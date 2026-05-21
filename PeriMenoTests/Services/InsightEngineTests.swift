import XCTest
@testable import PeriMeno

final class InsightEngineTests: XCTestCase {
    func testEmptyEntriesReturnPlaceholderInsight() {
        let snapshots = InsightEngine().makeOverviewSnapshots(from: [])
        XCTAssertFalse(snapshots.isEmpty)
    }
}
