//
//  Link.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/26.
//

import CoreGraphics
import Foundation

struct Link: Codable, Identifiable {
	let id: UUID
	let creatTime: Date
	let headNodeId: UUID
	let tailNodeId: UUID
	var headOffset: CGPoint
	var tailOffset: CGPoint

	init(head: Node, tail: Node, tailOffset: CGPoint) {
		self.id = UUID()
		self.creatTime = Date()
		self.headNodeId = head.id
		self.tailNodeId = tail.id
		self.headOffset = tailOffset
		self.tailOffset = tailOffset
	}
}
