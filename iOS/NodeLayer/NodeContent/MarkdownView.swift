//
//  MarkdownView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/23.
//

import MarkdownView
import SafariServices
import SwiftUI

struct Markdown: UIViewRepresentable {
	@Binding var markdown: String
	@Environment(\.loading) var showLoad: Binding<Bool>

	func makeUIView(context: Context) -> MarkdownView {
		let mdView = MarkdownView()
		mdView.isScrollEnabled = false
		mdView.onRendered = { _ in
			self.showLoad.wrappedValue = false
		}
		//		        mdView.onTouchLink = { request in
		//		          guard let url = request.url else { return false }
		//
		//		          if url.scheme == "file" {
		//		            return false
		//		          } else if url.scheme == "https" {
		//		            let safari = SFSafariViewController(url: url)
		//
		//
		//                    mdView.navigationController?.pushViewController(safari, animated: true)
		//		            return false
		//		          } else {
		//		            return false
		//		          }
		//		        }
		mdView.load(markdown: markdown, enableImage: true)

		return mdView
	}

	func updateUIView(_ mdView: MarkdownView, context: Context) {
		mdView.load(markdown: markdown, enableImage: true)
	}

}

extension UIView {
	func findViewController() -> UIViewController? {
		if let nextResponder = self.next as? UIViewController {
			return nextResponder
		} else if let nextResponder = self.next as? UIView {
			return nextResponder.findViewController()
		} else {
			return nil
		}
	}
}
