import XCTest

final class PremiumSmokeUITests: XCTestCase {
    func testPremiumScaffoldExists() {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments += ["-uiTestingSkipOnboarding", "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Home"].waitForExistence(timeout: 5))
    }
}
