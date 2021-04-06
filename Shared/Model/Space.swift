//
//  Space.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/25.
//

import Foundation

struct Space: Codable {
	var lastNodeId: UUID?
	var nodes: [Nid: Node]
	var links: [Lid: Link]
	var mode: ModeType
	var searchHistory: Set<String> = []
	init() {
		self.lastNodeId = nil
		self.nodes = [:]
		self.links = [:]
		self.mode = ModeType.link
		self.searchHistory = []
	}
	init(from space: Space) {
		self.lastNodeId = space.lastNodeId
		self.nodes = space.nodes
		self.links = space.links
		self.mode = space.mode
		self.searchHistory = space.searchHistory
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
