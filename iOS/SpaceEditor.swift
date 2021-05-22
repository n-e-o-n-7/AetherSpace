//
//  SpaceEditor.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/25.
//

import SwiftUI

struct SpaceEditor: View {
	@EnvironmentObject var svm: SpaceVM
	@EnvironmentObject var autoSave: AutoSave

	var body: some View {
		ZStack {
			if svm.space.mode == Space.ModeType.local {
				LocalmodeView()
			}
			if svm.space.mode == Space.ModeType.global {
				GlobalmodeView()
			}
			ToolLayer(showSearch: $showSearch)
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) { quit }
			ToolbarItem(placement: .navigationBarLeading) { backout }
			ToolbarItem(placement: .principal) { mode }
			ToolbarItem(placement: .navigationBarTrailing) { search }
			ToolbarItem(placement: .navigationBarTrailing) { more }
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarHidden(showSearch)
	}

	//MARK: - quit
	@AppStorage("cache") var cache: Bool = false
	@Environment(\.loading) var showLoad: Binding<Bool>
	var quit: some View {
		Button(
			action: {
				showLoad.wrappedValue.toggle()
				autoSave.setSave(frequency: 0)
				if cache {
					svm.clearCache()
				}
				autoSave.save()
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
					{}
				}
			},
			label: {
				Label("home", systemImage: "tray.full")
			}
		)
	}

	//MARK: - backout
	@ViewBuilder
	var backout: some View {
		if svm.stack.count != 0 {
			Button(
				action: {
					svm.backout()
				},
				label: {
					Label("backout", systemImage: "arrow.uturn.left.circle")
				}
			)
		}
	}

	//MARK: - mode
	var mode: some View {
		Picker(
			selection: $svm.space.mode,
			label: Text("mode")
		) {
			ForEach(Space.ModeType.allCases, id: \.self) { type in
				Label(type.rawValue, systemImage: "lasso.sparkles")
					.tag(Optional(type.rawValue))
					.labelStyle(TitleOnlyLabelStyle())
			}
		}.pickerStyle(SegmentedPickerStyle())
			.frame(width: 300)
	}

	//MARK: - search
	@State private var showSearch = false
	@State var searchText = "s"
	@ViewBuilder
	var search: some View {
		if !showSearch {
			Button(
				action: {
					showSearch = true
				},
				label: {
					Label("search", systemImage: "magnifyingglass")
				}
			)
		}
	}

	//MARK: - more
	@State var showSet = false
	var more: some View {
		Menu {
			Button(
				action: { showSet.toggle() },
				label: { Label("set", systemImage: "gearshape") }
			)
			Button(
				action: { autoSave.save() },
				label: { Label("save", systemImage: "doc") }
			)

		} label: {
			Label("more", systemImage: "ellipsis.circle.fill").font(.title2)
		}
		.menuStyle(DefaultMenuStyle())
		.sheet(isPresented: $showSet) {
			SetHome()
		}
	}
}
