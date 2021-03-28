//
//  Space.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/25.
//

import Foundation

struct Space: Codable {
	var lastNodeId: UUID?
	var nodes: [UUID: Node]
	var links: [UUID: Link]
	var mode: ModeType

	init() {
		self.lastNodeId = nil
		self.nodes = [:]
		self.links = [:]
		self.mode = ModeType.link
	}
	init(from space: Space) {
		self.lastNodeId = space.lastNodeId
		self.nodes = space.nodes
		self.links = space.links
		self.mode = space.mode
	}
}

extension Space {
	enum ModeType: String, CaseIterable, Codable {
		case link = "link"
		case order = "order"
		var systemImage: String {
			switch self {
			case .link:
				return "point.topleft.down.curvedto.point.bottomright.up"
			case .order:
				return "slider.vertical.3"

			}
		}
	}
}
