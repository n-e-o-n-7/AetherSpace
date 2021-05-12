//
//  AetherSpaceUITests.swift
//  AetherSpaceUITests
//
//  Created by 许滨麟 on 2021/4/24.
//

import XCTest

class AetherSpaceUITests: XCTestCase {
	var app: XCUIApplication!
	override func setUpWithError() throws {
		try super.setUpWithError()
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}

	func testLaunchPerformance() throws {
		if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
			measure(metrics: [
				XCTClockMetric(),
				XCTCPUMetric(),
				XCTStorageMetric(),
				XCTMemoryMetric(),
			]) {

				let app = XCUIApplication()
				app.navigationBars[
					"FullDocumentManagerViewControllerNavigationBar"
				].buttons[
					"FullDocumentManagerViewControllerNavigationBarCreateButtonIdentifier"
				].tap()
				app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Inbox Full"].tap()

			}
		}
	}
}
