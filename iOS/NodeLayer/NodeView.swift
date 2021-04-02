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
	@State var isLinking: Bool = false
	let linkSubject: PassthroughSubject<(Node, CGPoint), Never>

	var title: some View {
		HStack {
			Image(systemName: node.type.systemImage)
				.foregroundColor(.pink)
			Text(node.type.rawValue)
				.font(.caption)
				.fontWeight(.regular)
			Spacer()
			KnotView(node: node, linkSubject: linkSubject)
		}
		.font(.headline)
		.foregroundColor(.gray)
		.padding(9)
	}

	var body: some View {

		GeometryReader { proxy in
			ZStack {
				VStack(spacing: 0) {
					title
					Divider()
					NodeContentView(
						type: node.type,
						content: $node.content)
					Spacer()
				}
				.roundedBackground(radius: .small)
				.shadow(.base)
				.contextMenu {
					Button(
						action: { isLinking.toggle() },
						label: {
							Label("choose", systemImage: "dot.circle.and.cursorarrow")
						})
					Button(
						action: /*@START_MENU_TOKEN@*/ {} /*@END_MENU_TOKEN@*/,
						label: {
							Label("edit", systemImage: "square.and.pencil")
						})
					Button(
						action: /*@START_MENU_TOKEN@*/ {} /*@END_MENU_TOKEN@*/,
						label: {
							Label("delete", systemImage: "trash").foregroundColor(.red)
						})
				}
				//				.onTapGesture {
				//					print("change")
				//					svm.save(nextNode: node)
				//
				//				}
				if isLinking {
					BlurView(style: .systemMaterial)
				}
			}.onReceive(
				linkSubject,
				perform: { (sender, point) in
					print(point)
					let minX = proxy.frame(in: .global).minX
					let minY = proxy.frame(in: .global).minY
					let maxX = proxy.frame(in: .global).maxX
					let maxY = proxy.frame(in: .global).maxY
					if minX < point.x && point.x < maxX && minY < point.y && point.y < maxY {
						svm.addLink(head: sender, tail: node)
					}
				})
			//            .coordinateSpace(name: "nodeView")

		}
		.frame(width: 170, height: 140)
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
