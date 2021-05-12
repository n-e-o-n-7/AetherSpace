//
//  LinkmodeView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/5/8.
//

import MobileCoreServices
import SwiftUI

struct LocalmodeView: View {
	@EnvironmentObject var svm: SpaceVM
	@State var save = CGPoint.zero
	@State var extra = CGSize.zero
	//MARK: - nodeTrigger
	@State var position = CGPoint.zero
	@State var showPicker = false
	//MARK: - MagnificationGesture
	@GestureState var magnifyBy = CGFloat(1.0)
	var magnification: some Gesture {
		MagnificationGesture()
			.updating($magnifyBy) { currentState, gestureState, transaction in
				gestureState = currentState
			}
	}

	var body: some View {
		ZStack {
			GeometryReader { proxy in
				Background { offset in
					showPicker.toggle()
					position = offset
				}
				.onDrop(
					of: [String(kUTTypeURL)], isTargeted: nil,
					perform: { (items, point) in
						if let item = items.first {
							if item.canLoadObject(ofClass: URL.self) {
								let _ = item.loadObject(
									ofClass: URL.self,
									completionHandler: { (url, error) in
										let id = UUID(uuidString: url!.path)!
										if self.svm.nodes[id] == nil {
											DispatchQueue.main.async {
												let center = CGPoint(
													x: proxy.size.width / 2,
													y: proxy.size.height / 2)
												let extra = CGPoint(
													x: 0,
													y: UIScreen.main.bounds.size.height
														- proxy.size.height)
												withAnimation(.easeOut) {
													self.svm.nodePosition[id] = PositionVM(
														offset:
															point
															.subtract(extra)
															.subtract(center)
															.subtract(self.save))
													self.svm.nodes[id] = id
												}
											}
										}
									})
							}
						}
						return true
					}
				)
				.gesture(
					DragGesture()
						.onChanged { value in
							extra = value.translation
						}.onEnded { value in
							save = CGPoint(x: save.x + extra.width, y: save.y + extra.height)
							extra = CGSize.zero
						}
				)
				.padding(100)
				.background(Color("CanvasBackground"))
			}.edgesIgnoringSafeArea(.vertical)
			Group {
				LinkLayer()
				NodeLayer()
			}
			.scaleEffect(magnifyBy)
			.offset(x: save.x + extra.width, y: save.y + extra.height)

			NodeTrigger(position: $position, save: $save, isPresented: $showPicker)
		}.gesture(magnification)
	}
}
