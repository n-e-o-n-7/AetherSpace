//
//  SoundView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/22.
//

import SwiftUI

struct SoundContent: View {
	@Environment(\.presentationMode) var presentationMode
	@Binding var node: Node
	var content: NodeContent {
		node.contents.first!
	}
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
			.padding(15)
			VStack {
				Text(content.fileName!.replacingOccurrences(of: "%20", with: " "))
					.font(.largeTitle)
				Text(node.title)
					.font(.title3)
					.opacity(0.4)
				SoundShape(sound: content.data!)
			}.frame(minHeight: 0, maxHeight: .infinity)
		}
	}
}
