//
//  CanvasVM.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/16.
//

import Combine
import CoreData
import MobileCoreServices
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

	func addNode(type: Node.Species, content: NodeContent, position: CGPoint) {

		let newNode = Node(type: type, content: content)
		let nid = newNode.id
		if space.lastNodeId == nil {
			space.lastNodeId = nid
		}
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

		stack.append(.removeNode(node, np, oldLinks, oldSpace))
	}

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

	let saveSubject = PassthroughSubject<Int, Never>()
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
			space.links[lid] = link
			space.nodes[space.links[lid]!.headNodeId]!.asHeadLinkIds[lid] = lid
			space.nodes[space.links[lid]!.tailNodeId]!.asTailLinkIds[lid] = lid
			links[lid] = lid
		}
	}

}

extension SpaceVM: DropDelegate {

	//    func dropEntered(info: DropInfo) {
	//        NSSound(named: "Morse")?.play()
	//    }

	func performDrop(info: DropInfo) -> Bool {
		print(info.location)
		for provider in info.itemProviders(for: [String(kUTTypeURL)]) {
			if provider.canLoadObject(ofClass: URL.self) {
				let _ = provider.loadObject(
					ofClass: URL.self,
					completionHandler: { (url, error) in
						let id = UUID(uuidString: url!.path)!
						if self.nodes[id] == nil {
							DispatchQueue.main.async {
								withAnimation(.easeOut) {
									self.nodePosition[id] = PositionVM()
									self.nodes[id] = id
								}
							}
						}
					})
			}
		}
		return true
	}
}
