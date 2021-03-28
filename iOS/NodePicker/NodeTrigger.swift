//
//  NodeTrigger.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/6.
//

import SwiftUI

struct NodeTrigger: View {
	@Binding var position: CGPoint
	@Binding var isPresented: Bool
	@EnvironmentObject var svm: SpaceVM
	var body: some View {
		Color(.clear)
			.frame(width: 0, height: 0)
			//			.actionSheet(
			//				isPresented: $isPresented,
			//				content: {
			//					ActionSheet(
			//						title: Text("add new node"),
			//						buttons:
			//							Node.Species.allCases.map { specie in
			//								.default(Text(specie.rawValue)) {
			//									vm.addNode(type: specie, position: position)
			//								}
			//							})
			//				}
			//			)
			.popover(isPresented: $isPresented, arrowEdge: .leading) {
				NodePicker(confirm: addNode)
			}
			.offset(x: position.x - 0, y: position.y - 0)
	}

	func addNode(type: Node.Species, content: NodeContent) {
		svm.addNode(type: type, content: content, position: position)
		isPresented = false
	}
}
