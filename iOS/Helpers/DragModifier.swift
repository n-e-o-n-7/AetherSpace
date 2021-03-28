//
//  DragModifier.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/11.
//

import Combine
import Foundation
import SwiftUI

struct DragModifier: ViewModifier {

	@State var save = CGPoint.zero
	@State var extra = CGSize.zero

	func body(content: Content) -> some View {
		content
			.offset(x: save.x + extra.width, y: save.y + extra.height)
			.gesture(
				DragGesture()
					.onChanged { value in
						extra = value.translation

					}.onEnded { value in
						save = CGPoint(x: save.x + extra.width, y: save.y + extra.height)
						extra = CGSize.zero
					}
			)
	}

}

extension View {
	func dragable() -> some View {
		self.modifier(DragModifier())
	}
}
