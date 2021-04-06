//
//  ImageView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/22.
//

import SwiftUI

struct ImageContent: View {
	@Environment(\.presentationMode) var presentationMode
	@Binding var content: NodeContent
	var body: some View {
		VStack {
			HStack {
				Button("cancel") {
					presentationMode.wrappedValue.dismiss()
				}

				Spacer()

				Button("edit") {

				}
			}
			Image(uiImage: UIImage(data: content.data!)!)
				.resizable()
				.aspectRatio(contentMode: .fit)
		}.padding()

	}
}
