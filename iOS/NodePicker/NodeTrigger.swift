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
	@State var showAlert = false
	@State var errorMessage = ""
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
					.alert(isPresented: $showAlert) {
						Alert(title: Text(errorMessage))
					}
			}
			.offset(x: position.x - 0, y: position.y - 0)
	}

	func addNode(type: Node.Species, content: NodeContent) {
		guard content.title != "" else {
			errorMessage = "no title"
			showAlert = true
			return
		}
		switch type {
		case .image:
			if content.data == nil || content.fileName == "" {
				errorMessage = "no data"
				showAlert = true
				return
			}
		case .sound:
			if content.data == nil || content.fileName == "" {
				errorMessage = "no data"
				showAlert = true
				return
			}
		case .link:
			if content.url == "" {
				errorMessage = "no url"
				showAlert = true
				return
			}
		default: break
		}

		svm.addNode(type: type, content: content, position: position)
		isPresented = false
	}
}
