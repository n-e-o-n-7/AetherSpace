//
//  ActionButtonBackground.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/7.
//

import SwiftUI

struct ActionButtonBackgroundStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding(10)
			.foregroundColor(.white)
			.background(Color.accentColor)
			.clipShape(Capsule())
			.padding([.horizontal])
			.shadow(radius: configuration.isPressed ? 20.0 : 60.0)
			.scaleEffect(configuration.isPressed ? 0.95 : 1)
	}
}
