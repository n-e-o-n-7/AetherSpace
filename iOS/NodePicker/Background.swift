//
//  Background.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/21.
//

import SwiftUI

struct Background: UIViewRepresentable {
	var tappedCallback: ((CGPoint) -> Void)

	func makeUIView(context: UIViewRepresentableContext<Background>) -> UIView {
		let v = UIView(frame: .zero)
		let gesture = UITapGestureRecognizer(
			target: context.coordinator,
			action: #selector(Coordinator.tapped))
		v.addGestureRecognizer(gesture)
		return v
	}

	class Coordinator: NSObject {
		var tappedCallback: ((CGPoint) -> Void)
		init(tappedCallback: @escaping ((CGPoint) -> Void)) {
			self.tappedCallback = tappedCallback
		}
		@objc func tapped(gesture: UITapGestureRecognizer) {

			let point = gesture.location(in: gesture.view)
			let center = gesture.view!.center
			let offset = CGPoint(x: point.x - center.x, y: point.y - center.y)
			self.tappedCallback(offset)
		}
	}

	func makeCoordinator() -> Background.Coordinator {
		return Coordinator(tappedCallback: self.tappedCallback)
	}

	func updateUIView(
		_ uiView: UIView,
		context: UIViewRepresentableContext<Background>
	) {
	}

}
