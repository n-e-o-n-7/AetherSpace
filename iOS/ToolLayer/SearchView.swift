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
							Text("hide").padding(.trailing, 8)
						})

				}
				//				Picker(
				//					selection: /*@START_MENU_TOKEN@*/ .constant(1) /*@END_MENU_TOKEN@*/,
				//					label: /*@START_MENU_TOKEN@*/ Text("Picker") /*@END_MENU_TOKEN@*/
				//				) {
				//					Text("日期").tag(1)
				//					Text("内容").tag(2)
				//				}.pickerStyle(SegmentedPickerStyle())
				//
				//					.padding(.horizontal, 7)
				VStack {

					ScrollView(showsIndicators: false) {
						LazyVStack {
							ForEach((1...100), id: \.self) {
								Text("Placeholder \($0)")
							}
						}
					}

					HandleView()
				}.padding(.horizontal, 8)
					.padding(.top, 5)

			}
			.padding(5)
			.blurBackground()
			.cornerRadius(20, corners: [.topLeft, .bottomLeft])
			.frame(width: 340)
			.frame(maxHeight: 740)
			.shadow(.thick)
			.offset(x: 5)

			Spacer()
		}

	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(showSearch: .constant(true))
			.previewDevice("iPhone 11 Pro")
	}
}
