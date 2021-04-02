//
//  Operation.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/29.
//

import Foundation

enum Operation {
	case addNode(Nid)
	case removeNode(Node, PositionVM, [Lid: Lid], Space)
	case editNode(Node)
	case addLink(Link)
	case removeLink(Link)
}
