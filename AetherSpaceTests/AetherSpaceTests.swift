//
//  AetherSpaceTests.swift
//  AetherSpaceTests
//
//  Created by 许滨麟 on 2021/4/24.
//

import XCTest

@testable import AetherSpace

class AetherSpaceTests: XCTestCase {
	var test: SpaceVM!

	override func setUpWithError() throws {
		try super.setUpWithError()
		test = SpaceVM()
	}

	override func tearDownWithError() throws {
		test = nil
		try super.tearDownWithError()
	}

	func testInject() throws {
		var space = Space()
		let one = Node(title: "one", type: .tag, contents: [NodeContent()])
		space.nodes[one.id] = one
		space.lastNodeId = one.id

		test.inject(about: space)

		XCTAssertNotNil(test.space.lastNodeId)
		XCTAssertEqual(test.nodes.count, 1)
		XCTAssertEqual(test.links.count, 0)
	}

	func testInjectNil() throws {
		let space = Space()

		test.inject(about: space)

		XCTAssertNil(test.space.lastNodeId)
	}
}
