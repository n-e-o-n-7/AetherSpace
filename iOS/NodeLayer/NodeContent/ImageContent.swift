//
//  ImageView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/22.
//

import SwiftUI

struct ImageContent: View {
	@Environment(\.presentationMode) var presentationMode
	@Binding var node: Node
	var body: some View {
		VStack {
			HStack {
				Button("cancel") {
					presentationMode.wrappedValue.dismiss()
				}
				Spacer()
				EditButton()
			}.padding()
			ImageList(images: $node.contents)
				.listRowInsets(EdgeInsets())

		}

	}
}
