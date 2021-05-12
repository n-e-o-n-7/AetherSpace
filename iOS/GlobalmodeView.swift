//
//  GraphmodeView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/5/8.
//

import SwiftUI

struct GlobalmodeView: View {
	@EnvironmentObject var svm: SpaceVM

	@State private var linkSet: Set<Link> = []
	@State private var nodeDic: [Nid: Node] = [:]
	@State private var i = 1

	@State private var currentNode: Nid? = nil
	@AppStorage("mainColor") var mainColor = "blue"

	@State var save = CGPoint.zero
	@State var extra = CGSize.zero

	//MARK: - MagnificationGesture
	@GestureState private var magnifyBy = CGFloat(1.0)
	@State private var saveScale = CGFloat(1.0)
	var magnification: some Gesture {
		MagnificationGesture()
			.updating($magnifyBy) { currentState, gestureState, transaction in
				gestureState = currentState
			}.onEnded { finalState in
				saveScale *= finalState
			}
	}
	var links: [Link] {
		Array(linkSet)
	}
	var nodes: [Node] {
		nodeDic.map { $0.value }
	}

	var body: some View {
		ZStack {
			Background { _ in
				currentNode = nil
			}.padding(100)
				.background(Color("CanvasBackground"))
				.gesture(
					DragGesture()
						.onChanged { value in
							extra = value.translation
						}.onEnded { value in
							save = CGPoint(x: save.x + extra.width, y: save.y + extra.height)
							extra = CGSize.zero
						}
				)
				.gesture(magnification)
				.edgesIgnoringSafeArea(.vertical)

			ZStack {
				Group {
					ForEach(links, id: \.self) { link in
						LinkPath(
							headP: nodeDic[link.headId]!.pos, tailP: nodeDic[link.tailId]!.pos,
							dash: false
						)
						.stroke(ColorSet(rawValue: mainColor)!.toColor(), lineWidth: 7)
						.opacity(
							(currentNode == link.headId || currentNode == link.tailId) ? 1 : 0.2
						)
						.onTapGesture {
							print("link")
						}
					}
				}
				Group {
					ForEach(nodes, id: \.id) { node in
						ZStack {
							Circle().fill(ColorSet(rawValue: mainColor)!.toColor())
							Text(node.title).foregroundColor(.white)
						}.onTapGesture {
							currentNode = node.id
							print(node.id)
						}.frame(
							width: 30, height: 30
						).offset(x: node.pos.x, y: node.pos.y)
							.transition(.opacity)
					}
				}
			}.scaleEffect(magnifyBy * saveScale)
				.offset(x: save.x + extra.width, y: save.y + extra.height)
		}
		.onAppear {
			if let nid = svm.space.lastNodeId {
				linkSet = []
				nodeDic = [
					nid: Node(id: nid, title: svm.space.nodes[nid]!.title, pos: CGPoint.zero)
				]
				dfs(nid: nid)
			} else {
				linkSet = []
				nodeDic = [:]
			}
		}
	}

	//no link node
	func dfs(nid: Nid) {
		guard links.count < svm.space.links.count else { return }
		let node = svm.space.nodes[nid]!
		let newNodes =
			node.asHeadLinkIds.map { svm.space.links[$0.value]!.tailNodeId }
			+ node.asTailLinkIds.map { svm.space.links[$0.value]!.headNodeId }
		let center = nodeDic[nid]!.pos
		var count = Double(newNodes.filter { nodeDic[$0] == nil }.count)
		let aveAngle = 360 / count
		let h = 200.0
		newNodes.forEach { oNid in
			if nodeDic[oNid] == nil {
				count -= 1
				let angle = count * aveAngle * Double.pi / 180
				let pt = CGPoint(
					x: center.x + CGFloat(cos(angle) * h + Double.random(in: -50...50)),
					y: center.y + CGFloat(sin(angle) * h + Double.random(in: -50...50))
				)
				nodeDic[oNid] = Node(id: oNid, title: svm.space.nodes[oNid]!.title, pos: pt)
				linkSet.insert(Link(headId: nid, tailId: oNid))
				dfs(nid: oNid)
			} else {
				linkSet.insert(Link(headId: nid, tailId: oNid))
			}
		}
	}

	struct Link: Hashable {
		let headId: Nid
		let tailId: Nid

		func hash(into hasher: inout Hasher) {
			hasher.combine(self.headId)
			hasher.combine(self.tailId)
		}
	}

	struct Node: Identifiable {
		let id: Nid
		let title: String
		var pos: CGPoint
	}

}
