//
//  LinkLayer.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/16.
//

import SwiftUI

struct LinkLayer: View {

	@EnvironmentObject var svm: SpaceVM
	var lids: [Lid] {
		svm.links.map { $0.value }
	}
	var body: some View {
		ZStack {
			ForEach(lids, id: \.self) { lid in
				LinkView(
					lid: lid,
					headPVM: svm.nodePosition[svm.space.links[lid]!.headNodeId]!,
					tailPVM: svm.nodePosition[svm.space.links[lid]!.tailNodeId]!
				)

			}
		}
		//        .frame(width: 2, height: 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
		//        .offset(x: 1, y: 1)

	}
}
