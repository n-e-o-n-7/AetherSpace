//
//  ShadowModifier.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/21.
//

import SwiftUI

struct ShadowModifier: ViewModifier {
	let type: ShadowType
	@Environment(\.colorScheme) var colorScheme
	func body(content: Content) -> some View {
		switch type {
		case .base:
			return
				content
				.shadow(
					color: colorScheme == .light
						? Color.gray.opacity(0.2) : Color.black.opacity(0.2),
					radius: 20.0,
					x: CGFloat(0),
					y: CGFloat(0)
				)

		case .thick:
			return
				content
				.shadow(
					color: colorScheme == .light
						? Color.gray.opacity(0.4) : Color.black.opacity(0.4),
					radius: 14.0,
					x: CGFloat(0),
					y: CGFloat(0)
				)

		case .thin:
			return
				content
				.shadow(
					color: colorScheme == .light
						? Color.gray.opacity(0.1) : Color.black.opacity(0.1),
					radius: 30.0,
					x: CGFloat(0),
					y: CGFloat(4)
				)
		}
	}
}

enum ShadowType {
	case thin
	case base
	case thick
}
extension View {
	func shadow(_ type: ShadowType) -> some View {
		self.modifier(ShadowModifier(type: type))
	}
}
