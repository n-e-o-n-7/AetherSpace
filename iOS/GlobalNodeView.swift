//
//  GlobalNodeView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/5/22.
//

import SwiftUI

struct GlobalNodeView: View {
	let node: GlobalmodeView.Node
	let current: (Nid) -> Void
	@GestureState var isDetectingLongPress = false
	//	@State var completedLongPress = false
	@EnvironmentObject var svm: SpaceVM
	var longPress: some Gesture {
		LongPressGesture(minimumDuration: 0.5)
			.updating($isDetectingLongPress) {
				currentstate, gestureState,
				transaction in
				gestureState = currentstate
				transaction.animation = Animation.easeIn(duration: 0.4)
			}
			.onEnded { finished in
				//				self.completedLongPress = finished
				svm.jump(to: node.id)
				svm.space.mode = .local
			}
	}
	var body: some View {
		ZStack {
			Circle().fill(Color.white).frame(
				width: 30, height: 30
			).shadow(.base)
			Text(node.title).foregroundColor(
				Color.accentColor
			).frame(width: 70, height: 70)
		}
		.scaleEffect(isDetectingLongPress ? 1.5 : 1)
		.contentShape(Rectangle())
		.gesture(
			TapGesture(count: 1)
				.onEnded {
					current(node.id)
				}
				.simultaneously(with: longPress)
		)
		.offset(x: node.pos.x, y: node.pos.y)
		.transition(.opacity)

	}
}
