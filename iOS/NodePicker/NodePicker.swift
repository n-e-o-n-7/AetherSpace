//
//  NodePicker.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/23.
//

import SwiftUI

struct NodePicker: View {
	@Environment(\.presentationMode) var presentationMode
	@State private var title = ""
	let confirm: (Node.Species, NodeContent) -> Void
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack {
				Text("Add new node")
					.fontWeight(.bold)
					.font(.body)
				Spacer()
				Button(
					action: { self.presentationMode.wrappedValue.dismiss() },
					label: {
						Image(systemName: "xmark.circle.fill")
							.font(.title3).foregroundColor(.gray)
					})
			}
			.padding(10)

			Divider()

			VStack(alignment: .leading) {
				tp.padding(.bottom, 5)
				ScrollView(showsIndicators: false) {
					VStack(alignment: .leading) {
						Text("title").font(.caption).foregroundColor(.gray).fontWeight(.bold)
						TextField(
							"please enter title",
							text: $title
						) { isEditing in

						} onCommit: {

						}
						.autocapitalization(.none)
						.disableAutocorrection(true)
						//                    .border(Color(UIColor.separator))

						AddContent(nodeType: $nodeType, confirm: addNode)
					}
				}

			}.padding(10)
		}

		.frame(width: 300)

	}

	@State private var nodeType: Node.Species = Node.Species.tag

	var tp: some View {
		Picker(
			selection: $nodeType,
			label: Text("type")
		) {
			ForEach(Node.Species.allCases, id: \.self) { type in
				Label(type.rawValue, systemImage: type.systemImage)
					.tag(type)
					.labelStyle(TitleOnlyLabelStyle())
			}
		}.pickerStyle(SegmentedPickerStyle())
	}

	func addNode(content: NodeContent) {
		var content = content
		content.title = title
		confirm(nodeType, content)
	}
}
