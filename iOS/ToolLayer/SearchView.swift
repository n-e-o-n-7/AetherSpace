//
//  SearchView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/20.
//

import MobileCoreServices
import SwiftUI

struct SearchView: View {
	@EnvironmentObject var svm: SpaceVM
	@Binding var showSearch: Bool
	@State var searchText: String = ""
	var searchResult: [Node] {
		guard searchText != "" else { return [] }
		return svm.space.nodes.map { (_, node) in
			node
		}.filter { node in
			node.title.lowercased().contains(searchText.lowercased())
		}
	}
	var historys: [String] {
		Array(svm.space.searchHistory)
	}
	var body: some View {

		VStack(spacing: 0) {
			searchHead
			if searchText == "" {
				searchHistory
			} else {
				searchBody
			}
		}
		.blurBackground()
		.frame(width: 340)
		.frame(maxHeight: 740)
		.cornerRadius(20)
		//		.cornerRadius(20, corners: [.topLeft, .bottomLeft])
		.shadow(.thick)

	}

	var searchHead: some View {
		HStack(spacing: 0) {
			SearchBar(
				searchText: $searchText,
				onSearch: {
					svm.space.searchHistory.insert(searchText)
				})
			Button(
				action: {
					UIApplication.shared.sendAction(
						#selector(UIResponder.resignFirstResponder), to: nil,
						from: nil, for: nil)
					showSearch = false

				},
				label: {
					Text("Hide")

						.padding(.trailing, 3)
				})
		}.padding(5)
	}

	var searchHistory: some View {
		VStack(spacing: 5) {
			HStack {
				Text("Recent Searches")
					.opacity(0.7)
				Spacer()
				Button(
					action: {
						svm.space.searchHistory.removeAll()
					},
					label: {
						Text("clear").padding(.trailing, 8)
					})
			}
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading) {
					ForEach(historys, id: \.self) { history in
						Divider()
						Button(
							action: {
								self.searchText = history
							},
							label: {
								Text(history).padding(.trailing, 8)
							})
					}
				}
			}
			//			HandleView()
		}.padding(.leading, 13)
	}

	var searchBody: some View {

		ScrollView(showsIndicators: false) {
			LazyVStack(alignment: .leading, spacing: 10) {
				ForEach(searchResult, id: \.id) { node in
					//						Divider()
					HStack {
						SearchCell(node: node)
							.padding(9)
							.roundedBackground(radius: .mid)
							.onDrag({
								NSItemProvider(
									item: URL(string: node.id.uuidString)! as NSSecureCoding,
									typeIdentifier: String(kUTTypeURL))
							})
						Spacer()
						Button(
							action: {
								withAnimation {
									svm.jump(to: node)
								}
							},
							label: {
								Image(systemName: "arrow.right.circle.fill")
									.font(.title3)
							})
					}
					.padding(.trailing, 33)
					.roundedBackground(radius: .mid)
				}.offset(x: 13)
			}
		}
		//			HandleView()

	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(showSearch: .constant(true))
			.previewDevice("iPhone 11 Pro")
	}
}
