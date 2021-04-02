//
//  CanvasVM.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/16.
//

import Combine
import CoreData
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
	var nodePosition: [Nid: PositionVM] = [:]

	func initData() {
		links = [:]
		nodes = [:]
		nodePosition = [:]
		stack = []
	}
	func initData(node: Node) {

		links = node.asHeadLinkIds.merging(node.asTailLinkIds) { (ashead, _) in ashead }

		print(links)

		let HeadNodes = Dictionary(
			uniqueKeysWithValues: node.asTailLinkIds.map { (Lid, _) in
				(space.links[Lid]!.headNodeId, space.links[Lid]!.headNodeId)
			})

		let TailNodes = Dictionary(
			uniqueKeysWithValues: node.asHeadLinkIds.map { (Lid, _) in
				(space.links[Lid]!.tailNodeId, space.links[Lid]!.tailNodeId)
			})

		nodes = HeadNodes.merging(TailNodes) { (head, _) in head }

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

		stack = []
	}

	func addNode(type: Node.Species, content: NodeContent, position: CGPoint) {
		let newNode = Node(type: type, content: content)
		let nid = newNode.id

		space.nodes[nid] = newNode
		nodePosition[newNode.id] = PositionVM(offset: position)
		nodes[nid] = nid

		switch type {
		case .image, .sound:
			let token = SubscriptionToken()
			if let pub = upload(data: content.data, name: content.fileName) {
				pub.sink(
					receiveCompletion: { c in
						token.unseal()
					},
					receiveValue: { value in
						//MARK: - maybe change space

						self.space.nodes[nid]?.content.fileName = value.savePath
						//operation
					}
				)
				.seal(in: token)
			}
		default: break
		}

		stack.append(.addNode(nid))
	}

	func removeNode(nid: Nid) {
		nodes[nid] = nil
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

		stack.append(.removeNode(node, np, oldLinks, oldSpace))
	}

	func addLink(head: Node, tail: Node) {
		//MARK: -same link
		if head.id != tail.id {
			let newLink = Link(head: head, tail: tail)
			let lid = newLink.id

			space.links[lid] = newLink
			space.nodes[head.id]!.asHeadLinkIds[lid] = lid
			space.nodes[tail.id]!.asTailLinkIds[lid] = lid
			links[lid] = lid

			stack.append(.addLink(newLink))
		}

		//MARK: -no nowNode

	}

	func removeLink(lid: Lid) {
		let link = space.links[lid]!
		links[lid] = nil
		space.nodes[space.links[lid]!.headNodeId]!.asHeadLinkIds[lid] = nil
		space.nodes[space.links[lid]!.tailNodeId]!.asTailLinkIds[lid] = nil
		space.links[lid] = nil

		stack.append(.removeLink(link))
	}

	let saveSubject = PassthroughSubject<Int, Never>()
	func save(nextNode: Node? = nil) {
		print("save")
		if let nid = space.lastNodeId ?? nodes.popFirst()?.value {

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

			if let n = nextNode {
				space.lastNodeId = n.id
				self.initData(node: n)

			} else if space.lastNodeId == nil {
				space.lastNodeId = nid
			}
		}

	}

	//MARK: - published?
	var stack: [Operation] = []

	func backout() {
		guard let op = stack.popLast() else { return }
		switch op {
		case .addNode(let nid):
			nodes[nid] = nil
			nodePosition[nid] = nil
			space.nodes[nid] = nil
		case .removeNode(let node, let np, let oldLinks, let oldSpace):
			space = oldSpace
			nodePosition[node.id] = np
			links = oldLinks
			nodes[node.id] = node.id
		case .editNode(let _): break

		case .addLink(let link):
			links[link.id] = nil
			space.nodes[link.headNodeId]!.asHeadLinkIds[link.id] = link.id
			space.nodes[link.tailNodeId]!.asTailLinkIds[link.id] = link.id
			space.links[link.id] = link

		case .removeLink(let link):
			let lid = link.id
			space.nodes[space.links[lid]!.headNodeId]!.asHeadLinkIds[lid] = lid
			space.nodes[space.links[lid]!.tailNodeId]!.asTailLinkIds[lid] = lid
			space.links[lid] = link
			links[lid] = lid
		}

	}
}
