//
//  CanvasVM.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/16.
//

import SwiftUI

class SpaceVM: ObservableObject {
	@Published var space: Space

	init() {
		self.space = Space()
		initData()
	}
	func inject(about space: Space) {
		self.space = space
		if let nid = self.space.lastNodeId {
			initData(node: self.space.nodes[nid]!)
		} else {
			initData()
		}
	}

	@Published var links: [Lid: Lid] = [:]
	@Published var nodes: [Nid: Nid] = [:]
	@Published var nodePosition: [Nid: PositionVM] = [:]

	//MARK: - published?
	var stack: [Operation] = []

	func initData() {
		links = [:]
		nodes = [:]
		nodePosition = [:]
		stack = []
	}
	func initData(node: Node) {

		stack = []

		links = node.asHeadLinkIds.merging(node.asTailLinkIds) { (ashead, _) in ashead }

		let HeadNodes = Dictionary(
			uniqueKeysWithValues: node.asTailLinkIds.map { (Lid, _) in
				(space.links[Lid]!.headNodeId, space.links[Lid]!.headNodeId)
			})

		let TailNodes = Dictionary(
			uniqueKeysWithValues: node.asHeadLinkIds.map { (Lid, _) in
				(space.links[Lid]!.tailNodeId, space.links[Lid]!.tailNodeId)
			})

		nodes = HeadNodes.merging(TailNodes) { (head, _) in head }
		nodes[node.id] = node.id
		let HeadNodePosition = Dictionary(
			uniqueKeysWithValues: node.asTailLinkIds.map { (Lid, _) in
				(space.links[Lid]!.headNodeId, PositionVM(offset: space.links[Lid]!.headOffset))
			})
		let TailNodePosition = Dictionary(
			uniqueKeysWithValues: node.asHeadLinkIds.map { (Lid, _) in
				(space.links[Lid]!.tailNodeId, PositionVM(offset: space.links[Lid]!.tailOffset))
			})

		nodePosition = HeadNodePosition.merging(TailNodePosition) { (head, _) in head }

		nodePosition[node.id] = PositionVM()
	}
}

//MARK: - node operation
extension SpaceVM {
	func addNode(newNode: Node, position: CGPoint) {
		let nid = newNode.id
		if space.lastNodeId == nil {
			space.lastNodeId = nid
		}
		space.nodes[nid] = newNode
		nodePosition[newNode.id] = PositionVM(offset: position)
		nodes[nid] = nid

		switch newNode.type {
		case .image, .sound:
			newNode.contents.enumerated().forEach { (index, content) in
				let token = SubscriptionToken()
				if let pub = upload(data: content.data, name: content.fileName) {
					pub.sink(
						receiveCompletion: { c in
							token.unseal()
						},
						receiveValue: { value in
							//MARK: - maybe change space
							self.space.nodes[nid]?.contents[index].path = value.name
							//operation
						}
					)
					.seal(in: token)
				}
			}
		default: break
		}

		stack.append(.addNode(nid))
	}

	func removeNode(nid: Nid) {
		nodes[nid] = nil
		if nid == space.lastNodeId {
			if let first = nodes.first {
				space.lastNodeId = first.value
			} else {
				space.lastNodeId = nil
			}
		}
		let node = space.nodes[nid]!
		let oldLinks = links
		let oldSpace = space
		space.nodes[nid]!.asHeadLinkIds.forEach { (Lid, _) in
			space.nodes[space.links[Lid]!.tailNodeId]!.asTailLinkIds[Lid] = nil
			links[Lid] = nil
			space.links[Lid] = nil
		}
		space.nodes[nid]!.asTailLinkIds.forEach { (Lid, _) in
			space.nodes[space.links[Lid]!.headNodeId]!.asHeadLinkIds[Lid] = nil
			links[Lid] = nil
			space.links[Lid] = nil
		}
		let np = nodePosition[nid]!
		nodePosition[nid] = nil
		space.nodes[nid] = nil

		stack.append(.removeNode(node.id, np, oldLinks, oldSpace))
	}

	func hide(nid: Nid) {
		let oldLinks = links
		space.nodes[nid]!.asHeadLinkIds.forEach { (Lid, _) in
			links[Lid] = nil
		}
		space.nodes[nid]!.asTailLinkIds.forEach { (Lid, _) in
			links[Lid] = nil
		}
		let np = nodePosition[nid]!
		nodePosition[nid] = nil
		nodes[nid] = nil
		stack.append(.hideNode(nid, np, oldLinks))
	}
}

//MARK: - link operation
extension SpaceVM {
	func addLink(head: Nid, tail: Nid) {
		guard head != tail else { return }

		let newLink = Link(head: head, tail: tail)
		let lid = newLink.id

		guard space.links[lid] == nil else { return }

		space.links[lid] = newLink
		space.nodes[head]!.asHeadLinkIds[lid] = lid
		space.nodes[tail]!.asTailLinkIds[lid] = lid
		links[lid] = lid

		stack.append(.addLink(newLink))

		//MARK: -no nowNode

	}

	func removeLink(lid: Lid) {
		if space.links[lid] != nil {
			let link = space.links[lid]!
			links[lid] = nil
			space.nodes[space.links[lid]!.headNodeId]!.asHeadLinkIds[lid] = nil
			space.nodes[space.links[lid]!.tailNodeId]!.asTailLinkIds[lid] = nil
			space.links[lid] = nil

			stack.append(.removeLink(link))

			let generator = UINotificationFeedbackGenerator()
			generator.notificationOccurred(.success)
		}
	}

}

//MARK: - save
extension SpaceVM {
	func savePosition() {
		print("savePosition")
		if let nid = space.lastNodeId {
			links.forEach { (lid, _) in
				if space.links[lid]!.headNodeId == nid {
					space.links[lid]!.tailOffset = nodePosition[space.links[lid]!.tailNodeId]!.save
						.subtract(nodePosition[space.links[lid]!.headNodeId]!.save)
					if space.links[lid]!.justAdded {
						space.links[lid]!.headOffset = space.links[lid]!.tailOffset
						space.links[lid]!.justAdded = false
					}
				} else if space.links[lid]!.tailNodeId == nid {
					space.links[lid]!.headOffset = nodePosition[space.links[lid]!.headNodeId]!.save
						.subtract(nodePosition[space.links[lid]!.tailNodeId]!.save)
					if space.links[lid]!.justAdded {
						space.links[lid]!.tailOffset = space.links[lid]!.headOffset
						space.links[lid]!.justAdded = false
					}
				} else {
					space.links[lid]!.headOffset = nodePosition[space.links[lid]!.headNodeId]!.save
						.subtract(nodePosition[space.links[lid]!.tailNodeId]!.save)
					space.links[lid]!.tailOffset = space.links[lid]!.headOffset
					space.links[lid]!.justAdded = false
				}
			}
		}
	}

	func jump(to next: Node) {
		guard next.id != space.lastNodeId else { return }
		savePosition()
		space.lastNodeId = next.id
		self.initData(node: next)
	}

}

//MARK: - backout
extension SpaceVM {

	func backout() {
		guard let op = stack.popLast() else { return }
		switch op {
		case .addNode(let nid):
			nodes[nid] = nil
			nodePosition[nid] = nil
			space.nodes[nid] = nil
		case .removeNode(let nid, let np, let oldLinks, let oldSpace):
			space = oldSpace
			nodePosition[nid] = np
			links = oldLinks
			nodes[nid] = nid
		case .hideNode(let nid, let np, let oldLinks):
			nodePosition[nid] = np
			nodes[nid] = nid
			links = oldLinks
		case .addLink(let link):
			links[link.id] = nil
			space.nodes[link.headNodeId]!.asHeadLinkIds[link.id] = link.id
			space.nodes[link.tailNodeId]!.asTailLinkIds[link.id] = link.id
			space.links[link.id] = link
		case .removeLink(let link):
			let lid = link.id
			space.links[lid] = link
			space.nodes[space.links[lid]!.headNodeId]!.asHeadLinkIds[lid] = lid
			space.nodes[space.links[lid]!.tailNodeId]!.asTailLinkIds[lid] = lid
			links[lid] = lid
		}
	}

}
