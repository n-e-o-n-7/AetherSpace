//
//  RefView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/5/15.
//

import SwiftUI

struct RefView<Content: View>: UIViewControllerRepresentable {

	func makeCoordinator() -> Coordinator {
		return RefView.Coordinator(parent: self)
	}

	var view: () -> Content
	let key: String
	let ref: Ref

	init(
		key: String, ref: Ref, @ViewBuilder view: @escaping () -> Content
	) {
		self.view = view
		self.key = key
		self.ref = ref
	}

	func makeUIViewController(context: Context) -> UIViewController {
		let rootView = view()
		return UIHostingController(rootView: rootView)
	}

	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		if let view = uiViewController.view.subviews.first {
			ref.append(key: key, view: view)
		}
	}

	class Coordinator: NSObject {
		var parent: RefView
		init(parent: RefView) {
			self.parent = parent
		}
	}
}

@dynamicMemberLookup
class Ref: ObservableObject {
	private var dic: [String: UIView] = [:]

	func append(key: String, view: UIView) {
		dic[key] = view
	}

	func remove(key: String) {
		dic[key] = nil
	}

	subscript(dynamicMember member: String) -> UIView? {
		return dic[member]
	}
}
