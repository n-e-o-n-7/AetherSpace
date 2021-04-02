//
//  Link.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/26.
//

import CoreGraphics
import Foundation

struct Link: Codable, Identifiable {
	let id: Lid
	let creatTime: Date
	let headNodeId: Nid
	let tailNodeId: Nid
	var headOffset: CGPoint
	var tailOffset: CGPoint
	var justAdded: Bool

	init(head: Node, tail: Node) {
		self.id = Lid()
		self.creatTime = Date()
		self.headNodeId = head.id
		self.tailNodeId = tail.id
		self.headOffset = .zero
		self.tailOffset = .zero
		self.justAdded = true
	}
}
