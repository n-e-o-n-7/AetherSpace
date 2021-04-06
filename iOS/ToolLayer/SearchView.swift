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
			node.content.title!.lowercased().contains(searchText.lowercased())
		}
	}
	var historys: [String] {
		Array(svm.space.searchHistory)
	}
	var body: some View {
		VStack {
			VStack(spacing: 0) {
				searchHead
				if searchText == "" {
					searchHistory
				} else {
					searchBody
				}
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

	var searchHead: some View {
		HStack(spacing: 0) {
			SearchBar(
				searchText: $searchText,
				onSearch: {
					svm.space.searchHistory.insert(searchText)
				})
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
					Text("hide")
						.font(.title3)
						.padding(.trailing, 8)
				})

		}
	}

	var searchHistory: some View {
		VStack {
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
				LazyVStack(alignment: .leading) {

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
			HandleView()
		}
		.padding(.leading, 8)
		.padding(.top, 5)
	}

	var searchBody: some View {
		VStack {
			ScrollView(showsIndicators: false) {
				LazyVStack(alignment: .leading) {
					ForEach(searchResult, id: \.id) { node in
						Divider()
						SearchCell(node: node)
							.padding(9)
							.roundedBackground(radius: .mid)
							.onDrag({
								NSItemProvider(
									item: URL(string: node.id.uuidString)! as NSSecureCoding,
									typeIdentifier: String(kUTTypeURL))
							})
					}
				}
			}
			HandleView()
		}
		.padding(.leading, 8)
		.padding(.top, 5)
	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(showSearch: .constant(true))
			.previewDevice("iPhone 11 Pro")
	}
}
