//
//  ContentView.swift
//  Shared
//
//  Created by 许滨麟 on 2021/3/26.
//

import Combine
import SwiftUI

struct ContentView: View {

	@EnvironmentObject var autoSave: AutoSave
	@AppStorage("autosave") var autosave: TimeInterval = 60
	@AppStorage("mainColor") var mainColor = "blue"
	//MARK: - Notification
	@StateObject var delegate = NotificationDelegate()

	var body: some View {
		NavigationView {
			SpaceEditor()
				.canLoad()

				.onAppear {
					accessNotifications(delegate: delegate)
				}

				//MARK: - save
				.onAppear {
					autoSave.setSave(frequency: autosave)
				}
				.onChange(of: autosave) { time in
					autoSave.setSave(frequency: time)
				}

		}.navigationViewStyle(StackNavigationViewStyle())
			//MARK: - color
			.accentColor(ColorSet(rawValue: mainColor)!.toColor())
	}
}

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView(document: .constant(AetherSpaceDocument()))
//	}
//}
