//
//  MarkdownView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/23.
//

import MarkdownView
import SwiftUI

struct Markdown: UIViewRepresentable {
	@Binding var markdown: String
	func makeCoordinator() -> Coordinator {
		return Markdown.Coordinator(parent: self)
	}

	func makeUIView(context: Context) -> MarkdownView {
		let mdView = MarkdownView()
		mdView.isScrollEnabled = false
		mdView.load(markdown: markdown, enableImage: true)
		return mdView
	}

	func updateUIView(_ mdView: MarkdownView, context: Context) {
		mdView.load(markdown: markdown, enableImage: true)
	}

	class Coordinator: NSObject {

		var parent: Markdown

		init(parent: Markdown) {
			self.parent = parent
		}
	}
}
