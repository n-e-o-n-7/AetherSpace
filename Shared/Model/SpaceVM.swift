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
	let saveSubject = PassthroughSubject<Int, Never>()
	var space: Space {
		didSet {
			if let lastNodeId = space.lastNodeId {
				self.nowNode = self.space.nodes[lastNodeId]
			} else {
				self.nowNode = nil
			}
		}
	}

	@Published var nowNode: Node? = nil {
		didSet {
			if nowNode?.id != oldValue?.id {
				if let node = self.nowNode {
					print("nowNode change")
					initData(node: node)
				} else {
					initData()
				}
			}

		}
	}
	init() {
		self.space = Space()
	}
	//	deinit {
	//		debugPrint(space.id, "vm deinit")
	//		//MARK: - save? and fisrtnode
	//		if let nowNode = nowNode {
	//			space.lastNode = nowNode
	//		} else if let firstNode = nodes.first {
	//			space.lastNode = firstNode
	//		}
	//		viewContext.saveContext()
	//	}

	@Published var links: [Link] = []
	@Published var nodes: [Node] = []
	var nodePosition: [UUID: PositionVM] = [:]

	func initData() {
		links = []
		nodes = []
		nodePosition = [:]
	}
	func initData(node: Node) {
		let asHeadLinks = node.asHeadLinkIds.map { space.links[$0]! }
		let asTailLinks = node.asTailLinkIds.map { space.links[$0]! }

		links = asHeadLinks + asTailLinks

		let HeadNodes = asTailLinks.map { space.nodes[$0.headNodeId]! }
		let TailNodes = asHeadLinks.map { space.nodes[$0.tailNodeId]! }

		nodes = HeadNodes + TailNodes

		let HeadNodePosition = Dictionary(
			uniqueKeysWithValues: asTailLinks.map {
				($0.headNodeId, PositionVM(offset: $0.headOffset))
			})
		let TailNodePosition = Dictionary(
			uniqueKeysWithValues: asHeadLinks.map {
				($0.tailNodeId, PositionVM(offset: $0.tailOffset))
			})

		nodePosition = HeadNodePosition.merging(TailNodePosition) { (head, _) -> PositionVM in
			return head
		}
		nodePosition[node.id] = PositionVM()
		print(links.count)
	}

	func addNode(type: Node.Species, content: NodeContent, position: CGPoint) {
		let newNode = Node(type: type, content: content)
		let id = newNode.id
		switch type {
		case .image, .sound:
			let token = SubscriptionToken()
			if let pub = upload(data: content.data, name: content.fileName) {
				pub.sink(
					receiveCompletion: { c in
						token.unseal()
					},
					receiveValue: { value in
						//MARK: - maybe ?
						if let index = self.nodes.firstIndex(where: { $0.id == id }) {
							self.nodes[index].content.fileName = value.savePath
						}
					}
				)
				.seal(in: token)
			}
		default: break
		}

		nodes.append(newNode)
		nodePosition[newNode.id] = PositionVM(offset: position)
	}

	func addLink(head: Node, tail: Node) {
		//MARK: -same link
		//new node
		if head.id != tail.id {
			let newLink = Link(head: head, tail: tail, tailOffset: .zero)
			//nodes
			if let index = nodes.firstIndex(where: { $0.id == head.id }) {
				nodes[index].asHeadLinkIds.append(newLink.id)
			} else {
				nowNode?.asHeadLinkIds.append(newLink.id)
			}
			if let index = nodes.firstIndex(where: { $0.id == tail.id }) {
				nodes[index].asTailLinkIds.append(newLink.id)
			} else {
				nowNode?.asTailLinkIds.append(newLink.id)
			}
			links.append(newLink)
		}
		//MARK: -no nowNode

	}

	func save(nextNode: Node? = nil) {
		print("save")
		if let n = nowNode ?? nodes.first {

			let newLinks = links.map { link -> Link in

				var newlink = link

				if newlink.headNodeId == n.id {

					newlink.tailOffset = nodePosition[newlink.tailNodeId]!.save.subtract(
						nodePosition[newlink.headNodeId]!.save)

				} else if newlink.tailNodeId == n.id {

					newlink.headOffset = nodePosition[newlink.headNodeId]!.save.subtract(
						nodePosition[newlink.tailNodeId]!.save)

				} else {

					newlink.tailOffset = nodePosition[newlink.tailNodeId]!.save.subtract(
						nodePosition[newlink.headNodeId]!.save)
					newlink.headOffset = CGPoint(x: -newlink.tailOffset.x, y: -newlink.tailOffset.y)
				}
				return newlink
			}

			var newSpace = space
			newLinks.forEach { link in
				newSpace.links[link.id] = link

			}

			let newNodes = nowNode == nil ? nodes : nodes + [nowNode!]
			newNodes.forEach { node in
				newSpace.nodes[node.id] = node
			}

			newSpace.lastNodeId = nextNode?.id ?? n.id

			space = newSpace
		}

	}
}
