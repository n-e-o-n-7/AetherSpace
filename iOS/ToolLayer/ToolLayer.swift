//
//  ToolView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/24.
//

import SwiftUI

struct ToolLayer: View {
	@Binding var showSearch: Bool

	var body: some View {
		HStack(alignment: .top) {
			Spacer()
			if showSearch {
				SearchView(showSearch: $showSearch)
			}
		}
		.padding(.vertical, 40)
	}
}
