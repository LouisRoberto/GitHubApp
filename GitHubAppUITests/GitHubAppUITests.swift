//
//  GitHubAppUITests.swift
//  GitHubAppUITests
//
//  Created by Naoufal on 10/5/25.
//

import XCTest

final class GitHubAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }
    
    func testSearchFlow() {
        // Search for a user
        let searchField = app.searchFields["Search GitHub users..."]
        searchField.tap()
        searchField.typeText("apple\n")
        
        // Wait for results
        let firstCell = app.tables.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        // Tap on first result
        firstCell.tap()
        
        // Verify profile view
        XCTAssertTrue(app.staticTexts["apple"].waitForExistence(timeout: 2))
    }
    
    func testDarkModeSwitch() {
        // Go to profile view
        let searchField = app.searchFields["Search GitHub users..."]
        searchField.tap()
        searchField.typeText("apple\n")
        app.tables.cells.firstMatch.tap()
        
        // Verify initial appearance
        let screenshotBefore = app.windows.firstMatch.screenshot()
        
        // Change appearance (assuming you have a toggle in your app)
        app.buttons["AppearanceToggle"].tap()
        
        // Verify appearance changed
        let screenshotAfter = app.windows.firstMatch.screenshot()
        XCTAssertNotEqual(screenshotBefore.image.pngData(), screenshotAfter.image.pngData())
    }
}
