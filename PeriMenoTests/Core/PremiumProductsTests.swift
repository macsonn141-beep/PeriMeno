import XCTest
@testable import PeriMeno

final class PremiumProductsTests: XCTestCase {
    func testProductIdentifiersAreStable() {
        XCTAssertTrue(PremiumProducts.allIdentifiers.contains(PremiumProducts.monthly))
        XCTAssertTrue(PremiumProducts.allIdentifiers.contains(PremiumProducts.yearly))
        XCTAssertTrue(PremiumProducts.allIdentifiers.contains(PremiumProducts.lifetime))
    }
}
