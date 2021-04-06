//
//  NodeView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/5.
//

import Combine
import SwiftUI

struct NodeView: View {
	@Binding var node: Node
	@ObservedObject var pvm: PositionVM
	@EnvironmentObject var svm: SpaceVM

	let linkSubject: PassthroughSubject<(Nid, CGPoint), Never>

	var body: some View {

		NodeContentView(
			type: node.type,
			content: $node.content,
			knot: { KnotView(nid: node.id, linkSubject: linkSubject) }
		)
		.padding(9)
		.background(
			GeometryReader { proxy in
				RoundedRectangle(cornerRadius: CornerRadius.mid.rawValue)
					.fill(Color("NodeBackground"))
					.shadow(.base)
					.onReceive(
						linkSubject,
						perform: { (sender, point) in
							let minX = proxy.frame(in: .global).minX
							let minY = proxy.frame(in: .global).minY
							let maxX = proxy.frame(in: .global).maxX
							let maxY = proxy.frame(in: .global).maxY
							if minX < point.x && point.x < maxX && minY < point.y
								&& point.y < maxY
							{
								svm.addLink(head: sender, tail: node.id)
							}
						})
			}  //            .coordinateSpace(name: "nodeView")
		)
		.contextMenu {
			Button(
				action: {
					withAnimation(.easeInOut) {
						svm.jump(to: node)
					}
				},
				label: {
					Label("choose", systemImage: "dot.circle.and.cursorarrow")
				})
			Button(
				action: {},
				label: {
					Label("remove", systemImage: "square.and.pencil")
				})
			Button(
				action: { svm.removeNode(nid: node.id) },  //alert },
				label: {
					Label("delete", systemImage: "trash").foregroundColor(.red)
				})
		}
		.offset(x: pvm.save.x + pvm.extra.width, y: pvm.save.y + pvm.extra.height)
		.gesture(
			DragGesture()
				.onChanged { value in
					pvm.extra = value.translation
				}.onEnded { value in
					pvm.save = CGPoint(
						x: pvm.save.x + pvm.extra.width, y: pvm.save.y + pvm.extra.height)
					pvm.extra = CGSize.zero
				}
		)
	}
}
