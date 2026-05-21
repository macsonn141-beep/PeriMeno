import XCTest

final class InsightsSmokeUITests: XCTestCase {
    func testInsightsTabCanOpen() {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments += ["-uiTestingSkipOnboarding", "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()

        let insightsTab = app.tabBars.buttons["Insights"]
        XCTAssertTrue(insightsTab.waitForExistence(timeout: 5))
        insightsTab.tap()

        XCTAssertTrue(app.navigationBars["Insights"].waitForExistence(timeout: 5))
    }
}
