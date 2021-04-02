//
//  ContentView.swift
//  Shared
//
//  Created by 许滨麟 on 2021/3/26.
//

import Combine
import SwiftUI

struct ContentView: View {
	//MARK: - Notification
	@StateObject var delegate = NotificationDelegate()
	var body: some View {

		return SpaceEditor().onAppear(
			perform: {
				accessNotifications(delegate: delegate)

			}
		)

	}
}

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView(document: .constant(AetherSpaceDocument()))
//	}
//}
