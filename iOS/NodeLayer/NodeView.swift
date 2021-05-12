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
	@Binding var top: Nid?
	@ObservedObject var pvm: PositionVM
	@EnvironmentObject var svm: SpaceVM
	let linkSubject: PassthroughSubject<(Nid, CGPoint), Never>
	@State var showAlert = false

	var body: some View {
		NodeContentView(
			node: $node,
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
							let pos = proxy.frame(in: .global)
							if pos.minX < point.x && point.x < pos.maxX && pos.minY < point.y
								&& point.y < pos.maxY
							{
								svm.addLink(head: sender, tail: node.id)
							}
						})
			}
		)
		.contextMenu {
			Button(
				action: {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
						withAnimation(.easeInOut) {
							svm.jump(to: node)
						}
					}
				},
				label: {
					Label("choose", systemImage: "cursorarrow.rays")
				})
			Button(
				action: { top = node.id },
				label: {
					Label("front", systemImage: "rectangle.stack")
				})
			Button(
				action: { svm.hide(nid: node.id) },
				label: {
					Label("hide", systemImage: "eye.slash")
				})
			Button(
				action: {
					if node.id == svm.space.lastNodeId {
						showAlert.toggle()
					} else {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
							withAnimation(.easeInOut) {
								svm.removeNode(nid: node.id)
							}
						}
					}
				},
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
		.alert(isPresented: $showAlert) {
			Alert(
				title: Text("this is the center node"),
				message: Text("please confirm whether to delete"),
				primaryButton: .destructive(Text("delete")) { svm.removeNode(nid: node.id) },
				secondaryButton: .cancel())
		}
	}
}
