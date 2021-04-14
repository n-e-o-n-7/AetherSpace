//
//  GradientText.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/12.
//

import SwiftUI

struct GradientText: View {
	let text = Text("SwiftUI is awesome!").font(.largeTitle)

	let gradient = LinearGradient(
		gradient: Gradient(colors: [.red, .orange]),
		startPoint: .topLeading,
		endPoint: .bottomTrailing)

	var body: some View {
		text
			.foregroundColor(.clear)
			.overlay(
				gradient.mask(
					text
						.scaledToFill()
				)
			)
	}
}

struct GradientText_Previews: PreviewProvider {
	static var previews: some View {
		GradientText()
	}
}
