//
//  SearchNavigation.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/6.
//

import SwiftUI

struct SearchNavigation: UIViewControllerRepresentable {

	func makeCoordinator() -> Coordinator {

		return SearchNavigation.Coordinator(parent: self)
	}

	var view: AnyView

	var largeTitle: Bool
	var title: String
	var placeHolder: String

	var onSearch: (String) -> Void
	var onCancel: () -> Void

	init(
		view: AnyView, placeHolder: String? = "Search", largeTitle: Bool? = true, title: String,
		onSearch: @escaping (String) -> Void, onCancel: @escaping () -> Void
	) {

		self.largeTitle = largeTitle!
		self.title = title
		self.placeHolder = placeHolder!
		self.view = view
		self.onSearch = onSearch
		self.onCancel = onCancel
	}

	func makeUIViewController(context: Context) -> UINavigationController {

		let childView = UIHostingController(rootView: view)

		let controller = UINavigationController(rootViewController: childView)

		controller.navigationBar.topItem?.title = "title"
		controller.navigationBar.prefersLargeTitles = largeTitle

		let searchController = UISearchController()
		searchController.searchBar.placeholder = placeHolder

		searchController.searchBar.delegate = context.coordinator

		searchController.obscuresBackgroundDuringPresentation = false

		controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
		controller.navigationBar.topItem?.searchController = searchController

		return controller
	}

	func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {

		uiViewController.navigationBar.topItem?.title = nil
		uiViewController.navigationBar.topItem?.searchController?.searchBar.placeholder =
			placeHolder
		uiViewController.navigationBar.prefersLargeTitles = largeTitle
	}

	class Coordinator: NSObject, UISearchBarDelegate {

		var parent: SearchNavigation

		init(parent: SearchNavigation) {
			self.parent = parent
		}

		func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

			self.parent.onSearch(searchText)
		}

		func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

			self.parent.onCancel()
		}
	}
}
