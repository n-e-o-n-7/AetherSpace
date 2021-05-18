//
//  CheckboxStyle.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/5/17.
//
import SwiftUI

struct CheckboxStyle: ToggleStyle {

	func makeBody(configuration: Self.Configuration) -> some View {

		HStack {

			configuration.label

			Spacer()

			Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
				.resizable()
				.frame(width: 24, height: 24)
				.foregroundColor(configuration.isOn ? .accentColor : .gray)
				//				.font(.system(size: 20, weight: .bold, design: .default))
				.onTapGesture {
					configuration.isOn.toggle()
				}
		}

	}
}
