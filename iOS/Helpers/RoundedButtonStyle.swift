//
//  RoundedButtonStyle.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/12.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {

		RoundedRectangle(cornerRadius: CornerRadius.mid.rawValue)
			.fill(Color.accentColor)
			.frame(width: 344, height: 52)
			.overlay(
				configuration.label
					.foregroundColor(.white)
			)
			.padding()
	}
}
