//
//  LinkLayer.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/16.
//

import SwiftUI

struct LinkLayer: View {

	@EnvironmentObject var svm: SpaceVM

	var body: some View {
		ZStack {
			ForEach(svm.links, id: \.id) { link in
				LinkView(
					headPVM: svm.nodePosition[link.headNodeId]!,
					tailPVM: svm.nodePosition[link.tailNodeId]!
				)

			}
		}
		//        .frame(width: 2, height: 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
		//        .offset(x: 1, y: 1)

	}
}
