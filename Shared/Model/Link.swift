//
//  Link.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/26.
//

import CoreGraphics
import Foundation

struct Link: Codable {

	let creatTime: Date
	let headNodeId: Nid
	let tailNodeId: Nid
	var headOffset: CGPoint
	var tailOffset: CGPoint
	var justAdded: Bool

	init(head: Nid, tail: Nid) {

		self.creatTime = Date()
		self.headNodeId = head
		self.tailNodeId = tail
		self.headOffset = .zero
		self.tailOffset = .zero
		self.justAdded = true
	}
}

extension Link: Identifiable {
	var id: Lid {
		self.hashValue
	}
}

extension Link: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.headNodeId)
		hasher.combine(self.tailNodeId)
	}
}
