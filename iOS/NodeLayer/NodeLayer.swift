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

	let linkSubject = PassthroughSubject<(Node, CGPoint), Never>()

	var body: some View {

		ZStack {

			if svm.nowNode != nil {
				ZStack {
					NodeView(
						node: $svm.nowNode.unwrap()!, pvm: svm.nodePosition[svm.nowNode!.id]!,
						linkSubject: linkSubject)
				}
			}
			ForEach($svm.nodes, id: \.id) { node in
				NodeView(
					node: node, pvm: svm.nodePosition[node.wrappedValue.id]!,
					linkSubject: linkSubject)
			}
		}

	}
}
