//
//  NodeTrigger.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/6.
//

import SwiftUI

struct NodeTrigger: View {
	@Binding var position: CGPoint
	@Binding var save: CGPoint
	@Binding var isPresented: Bool
	@EnvironmentObject var svm: SpaceVM
	var body: some View {
		Color(.clear)
			.frame(width: 1, height: 1)
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
			.popover(isPresented: $isPresented, arrowEdge: .top) {
				NodePicker(confirm: addNode)
			}
			.offset(x: position.x, y: position.y)
	}

	func addNode(node: Node) {
		svm.addNode(newNode: node, position: position.subtract(save))
		isPresented = false
	}
}
