//
//  SearchView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/20.
//

import SwiftUI

struct SearchView: View {

	@Binding var showSearch: Bool

	var body: some View {

		VStack {
			VStack(spacing: 0) {

				HStack(spacing: 0) {
					SearchBar { text in
					}
					Button(
						action: {
							withAnimation {
								UIApplication.shared.sendAction(
									#selector(UIResponder.resignFirstResponder), to: nil,
									from: nil, for: nil)
								showSearch = false
							}
						},
						label: {
							Text("hide").padding(.trailing, 10)
						})

				}

				ScrollView {
					LazyVStack {
						ForEach((1...100), id: \.self) {
							Text("Placeholder \($0)")
						}
					}
				}
				.padding(.horizontal, 10)
				.padding(.vertical, 5)

				HandleView()
			}
			.padding(5)
			.blurBackground()
			.cornerRadius(20, corners: [.topLeft, .bottomLeft])
			//				.background(Color("NodeBackground"))
			.frame(width: 340)
			.frame(maxHeight: 740)

			.shadow(.thick)

			Spacer()
		}

	}
}
