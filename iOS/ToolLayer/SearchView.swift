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

	var nodes: [Node] {
		svm.space.nodes.map { (_, node) in node }
	}
	var searchResult: [Node] {
		guard searchText != "" else { return [] }
		return nodes.filter { node in
			node.title.lowercased().contains(searchText.lowercased())
		}
	}
	var filterResult: [Node] {
		guard showFilter else { return searchResult }
		return searchResult.filter { node in
			node.type == nodeType
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
		.padding(.trailing, 20)
		.cornerRadius(20)
		.offset(x: 20)
		.shadow(.thick)

	}
	@State private var showFilter = false

	var searchHead: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				SearchBar(
					searchText: $searchText,
					onSearch: { svm.space.searchHistory.insert(searchText) },
					onMark: { withAnimation { showFilter.toggle() } })
				Button(
					action: {
						UIApplication.shared.sendAction(
							#selector(UIResponder.resignFirstResponder), to: nil,
							from: nil, for: nil)
						showSearch = false
					},
					label: { Text("Hide").padding(.trailing, 3) })
			}.padding(.horizontal, 5)
			if showFilter {
				typePicker
					.padding(.horizontal, 13)
					.padding(.bottom, 8)
			}
		}.padding(.vertical, 5)

	}
	@State private var nodeType: Node.Species = Node.Species.tag
	var typePicker: some View {
		Picker(
			"",
			selection: $nodeType
		) {
			ForEach(Node.Species.allCases, id: \.self) { type in
				Label(type.rawValue, systemImage: type.systemImage)
					.tag(type)
					.labelStyle(TitleOnlyLabelStyle())
			}
		}.pickerStyle(SegmentedPickerStyle())
	}
	//	@State private var start = Date()
	//	@State private var end = Date()
	//	var datePicker: some View {
	//		HStack {
	//			DatePicker("", selection: $start, displayedComponents: [.date]).labelsHidden()
	//				.accentColor(Color("TextColor"))
	//				.scaleEffect(0.9, anchor: .leading)
	//			Spacer()
	//			Image(systemName: "arrow.right")
	//			Spacer()
	//			DatePicker("", selection: $end, displayedComponents: [.date]).labelsHidden()
	//				.accentColor(Color("TextColor"))
	//				.scaleEffect(0.9, anchor: .trailing)
	//		}
	//	}
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
				}.padding(.bottom, 13)
			}
			//			HandleView()
		}.padding(.leading, 13)

	}

	var searchBody: some View {

		ScrollView(showsIndicators: false) {
			LazyVStack(alignment: .leading, spacing: 10) {
				ForEach(filterResult, id: \.id) { node in
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
				}
				.offset(x: 13)
			}
			.padding(.bottom, 13)
		}
		//			HandleView()
	}
}

//struct SearchView_Previews: PreviewProvider {
//	static var previews: some View {
//		SearchView(showSearch: .constant(true))
//			.previewDevice("iPhone 11 Pro")
//	}
//}
