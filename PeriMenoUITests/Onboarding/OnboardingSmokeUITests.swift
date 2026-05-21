import XCTest

final class OnboardingSmokeUITests: XCTestCase {
    func testAppLaunches() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.exists)
    }

    func testContinueButtonIsVisibleAndAdvances() {
        let app = XCUIApplication()
        app.launch()

        let continueButton = app.buttons["onboarding.continue.button"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 5))
        XCTAssertTrue(continueButton.isHittable)

        continueButton.tap()

        let stepTitle = app.staticTexts["onboarding.step.title"]
        XCTAssertTrue(stepTitle.waitForExistence(timeout: 2))
        XCTAssertEqual(stepTitle.label, "Track what matters")
    }
}
