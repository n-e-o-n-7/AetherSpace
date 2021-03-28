//
//  RoundedBackgroundModifier.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/22.
//

import SwiftUI

struct RoundedBackgroundModifier: ViewModifier {
	let radius: CornerRadius
	let color: Color

	func body(content: Content) -> some View {
		return
			content
			.background(
				RoundedRectangle(cornerRadius: radius.rawValue)
					.fill(color)
			)
	}
}
extension View {
	func roundedBackground(
		radius: CornerRadius = CornerRadius.mid, color: Color = Color("NodeBackground")
	) -> some View {
		self.modifier(RoundedBackgroundModifier(radius: radius, color: color))
	}
}
enum CornerRadius: CGFloat {
	case large = 25
	case mid = 17
	case small = 15
	case ssmall = 10
}
