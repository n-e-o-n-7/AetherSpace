//
//  NodePicker.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/23.
//

import SwiftUI

struct NodePicker: View {
	@Environment(\.presentationMode) var presentationMode
	@State var showAlert = false
	@State var errorMessage = ""
	@State private var title = ""
	let confirm: (Node) -> Void
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
		.alert(isPresented: $showAlert) {
			Alert(title: Text(errorMessage))
		}
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

	func addNode(contents: [NodeContent]) {
		guard title != "" else {
			errorMessage = "no title"
			showAlert = true
			return
		}
		switch nodeType {
		case .image:
			for content in contents {
				if content.data == nil || content.fileName == "" {
					errorMessage = "no data"
					showAlert = true
					return
				}
			}
		case .sound:
			for content in contents {
				if content.data == nil || content.fileName == "" {
					errorMessage = "no data"
					showAlert = true
					return
				}
			}
		case .link:
			if contents.first!.url! == "" {
				errorMessage = "no url"
				showAlert = true
				return
			} else if urlReg.matches(
				in: contents.first!.url!, options: [],
				range: NSMakeRange(0, contents.first!.url!.count)
			).count == 0 {
				errorMessage = "wrong url"
				showAlert = true
				return
			}
		default: break
		}
		let newNode = Node(title: title, type: nodeType, contents: contents)
		confirm(newNode)
	}
}
