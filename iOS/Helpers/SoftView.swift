//
//  SoftView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/12.
//

import SwiftUI

struct SoftView: View {
	var body: some View {
		HStack {
			Text("Enter message")
			Button(
				action: {

				},
				label: {
					// SF Symbols
					Image(systemName: "paperplane.fill")
				})
		}.padding()
			.background(
				Color(
					#colorLiteral(
						red: 0.9013931155, green: 0.9015443325, blue: 0.901373148, alpha: 1))
			)
			.clipShape(
				RoundedRectangle(
					cornerRadius: 10.0,
					style: /*@START_MENU_TOKEN@*/ .continuous /*@END_MENU_TOKEN@*/)
			)
			.shadow(
				color: Color(
					#colorLiteral(
						red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
				radius: 8, x: 8, y: 8
			)
			.shadow(color: .white, radius: 8, x: -8, y: -8)

	}
}

struct SoftView_Previews: PreviewProvider {
	static var previews: some View {
		SoftView()
	}
}
