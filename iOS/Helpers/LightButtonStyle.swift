//
//  lightButtonStyle.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/24.
//

import SwiftUI

struct LightButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {

		Color.accentColor.opacity(0.3)
			.cornerRadius(CornerRadius.ssmall.rawValue)
			.overlay(
				configuration.label
					.foregroundColor(.accentColor)
			)
	}
}
