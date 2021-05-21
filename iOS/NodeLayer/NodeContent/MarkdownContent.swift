//
//  MarkdownContent.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/23.
//

import MarkdownUI
import SwiftUI
import UniformTypeIdentifiers

struct MarkdownContent: View {
	@Environment(\.presentationMode) var presentationMode
	@Binding var node: Node
	@State var show = false
	@State var importfile = false
	var body: some View {

		VStack {
			HStack {
				Button("cancel") {
					presentationMode.wrappedValue.dismiss()
				}
				Spacer()
				Button(show ? "done" : "edit") {
					show.toggle()
				}
			}
			.padding(.horizontal, 15)
			.padding(.top, 15)
			Spacer()
			GeometryReader { proxy in
				if show {
					HStack(spacing: 0) {
						Spacer()
						TextEditor(text: $node.contents[0].markdown.unwrap()!).padding(.trailing)
							.frame(
								width: 0.6 * proxy.size.width,
								alignment: .center
							).introspectTextView { textView in
								textView.showsVerticalScrollIndicator = false
								textView.backgroundColor = UIColor.clear
								textView.inputAccessoryView = MdInputAccessoryView(text: textView)
							}
						FodderPanel(nid: node.id).frame(
							width: 0.2 * proxy.size.width,
							alignment: .center
						)
					}
				} else {
					HStack {
						Spacer()
						ScrollView(showsIndicators: false) {
							Markdown(Document(node.contents[0].markdown!))
								.markdownStyle(
									DefaultMarkdownStyle(
										font: .system(.body, design: .serif),
										codeFontName: "Menlo",
										codeFontSizeMultiple: 0.88
									)
								)
						}.padding(.trailing).frame(
							width: 0.6 * proxy.size.width, height: proxy.size.height)
						//							.canLoad(state: true, opacity: 0, scale: 1)
						Spacer()
					}

				}
			}.padding(.bottom)
		}
	}
}

//struct MarkdownContent_Previews: PreviewProvider {
//	static var previews: some View {
//        MarkdownContent(presentationMode: .constant(true),markdown: Binding(example))
//	}
//}
