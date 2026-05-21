import XCTest

final class LoggingSmokeUITests: XCTestCase {
    func testRootTabRenders() {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments += ["-uiTestingSkipOnboarding", "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Home"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.navigationBars["Home"].waitForExistence(timeout: 5))
    }
}
