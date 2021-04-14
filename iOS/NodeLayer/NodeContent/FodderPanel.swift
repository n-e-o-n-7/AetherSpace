//
//  FodderPanel.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/7.
//

import SwiftUI

struct FodderPanel: View {
	let nid: Nid
	@EnvironmentObject var svm: SpaceVM
	var fodders: [Node] {
		let node = svm.space.nodes[nid]!
		let headNode = node.asTailLinkIds.map { (_, lid) in
			svm.space.nodes[svm.space.links[lid]!.headNodeId]!
		}
		let tailNode = node.asHeadLinkIds.map { (_, lid) in
			svm.space.nodes[svm.space.links[lid]!.tailNodeId]!
		}
		let result = (headNode + tailNode).filter { node in
			node.type == .link || node.type == .image
		}
		return result
	}
	var body: some View {
		VStack {
			ScrollView(showsIndicators: false) {
				LazyVStack(alignment: .leading, spacing: 10) {
					ForEach(fodders, id: \.id) { fodder in
						FodderCell(node: fodder)
							.padding(9)
							.padding(.trailing, 15)
							.blurBackground()
							.cornerRadius(20, corners: [.topLeft, .bottomLeft])
					}
				}
			}
		}
	}
}

//struct FodderPanel_Previews: PreviewProvider {
//    static var previews: some View {
//        FodderPanel()
//    }
//}
