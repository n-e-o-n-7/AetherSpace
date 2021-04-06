//
//  NodeLayer.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/5.
//

import Combine
import SwiftUI

struct NodeLayer: View {

	@EnvironmentObject var svm: SpaceVM
	var nids: [Nid] {
		svm.nodes.map { $0.value }
	}
	let linkSubject = PassthroughSubject<(Nid, CGPoint), Never>()

	var body: some View {

		ZStack {
			//			if let nid = svm.space.lastNodeId {
			//
			//				NodeView(
			//					node: Binding(
			//						get: { svm.space.nodes[nid]! },
			//						set: { newValue in
			//							svm.space.nodes[nid] = newValue
			//						}
			//					), pvm: svm.nodePosition[nid]!,
			//					linkSubject: linkSubject)
			//
			//			}
			ForEach(nids, id: \.self) { nid in
				NodeView(
					node: $svm.space.nodes[nid].unwrap()!, pvm: svm.nodePosition[nid]!,
					linkSubject: linkSubject)
			}
		}
	}
}
