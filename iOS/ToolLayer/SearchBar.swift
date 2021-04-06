//
//  SearchBar.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/6.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {

	func makeCoordinator() -> Coordinator {
		return SearchBar.Coordinator(parent: self)
	}

	@Binding var searchText: String
	var onSearch: () -> Void

	func makeUIView(context: Context) -> UISearchBar {

		let searchBar = UISearchBar()

		searchBar.searchBarStyle = .minimal
		//		searchBar.showsCancelButton = true
		searchBar.autocapitalizationType = .none
		searchBar.delegate = context.coordinator
		searchBar.placeholder = "Search"

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
			searchBar.becomeFirstResponder()
		}
		//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

		return searchBar
	}

	func updateUIView(_ uiView: UISearchBar, context: Context) {
		uiView.text = searchText
	}

	class Coordinator: NSObject, UISearchBarDelegate {

		var parent: SearchBar

		init(parent: SearchBar) {
			self.parent = parent
		}

		func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			self.parent.searchText = searchText
		}
		func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
			self.parent.onSearch()
		}

		//		func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		//
		//			self.parent.onCancel()
		//		}
	}
}
